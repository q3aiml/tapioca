# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require "minitest/spec"
require "tapioca/helpers/test/content"
require "tapioca/helpers/test/template"
require "tapioca/helpers/test/isolation"

class DslSpec < Minitest::Spec
  extend T::Sig
  include Kernel
  include Tapioca::Helpers::Test::Content
  include Tapioca::Helpers::Test::Template
  include Tapioca::Helpers::Test::Isolation

  sig { void }
  def after_setup
    # Require the file that the target class should be loaded from
    require @@compiler_require_file
  end

  # sig { void }
  # def teardown
  #   super
  #   # T.unsafe(self).subject.errors.clear
  # end

  @@compiler_hydrator = T.let(nil, T.nilable(T.proc.returns(T.class_of(Tapioca::Compilers::Dsl::Base))))
  @@compiler_require_file = T.let(nil, T.nilable(String))
  @@compiler = T.let(nil, T.nilable(T.class_of(Tapioca::Compilers::Dsl::Base)))

  sig { params(blk: T.proc.returns(T.class_of(Tapioca::Compilers::Dsl::Base))).void }
  def self.compiler_under_test(&blk)
    @@compiler_hydrator = blk
  end

  sig { params(path: String).void }
  def self.compiler_require(path)
    @@compiler_require_file = path
  end

  sig {params(require_file: String).void }
  def activate_compiler(require_file)
    @@compiler = nil
    Kernel.require(require_file)
  end

  sig { returns(T.class_of(Tapioca::Compilers::Dsl::Base)) }
  def compiler
    @@compiler ||= @@compiler_hydrator&.call or raise "no compiler defined"
  end

  # subject do
  #   T.bind(self, DslSpec)
  #   # Get the class under test and initialize a new instance of it as the "subject"
  #   generator_for_names(target_class_name)
  # end

  # sig { params(names: String).returns(T.class_of(Tapioca::Compilers::Dsl::Base)) }
  # def generator_for_names(*names)
  #   raise "name is required" if names.empty?

  #   classes = names.map { |class_name| Object.const_get(class_name) }

  #   compiler = Tapioca::Compilers::DslCompiler.new(
  #     requested_constants: [],
  #     requested_generators: classes
  #   )

  #   T.must(compiler.generators.find { |generator| generator.name == names.first })
  # end

  sig { returns(Class) }
  def self.spec_test_class
    # Find the spec test class
    klass = T.let(self, Class)

    # It should be the one that directly inherits from DslSpec
    while (superclass = klass.superclass) && superclass != DslSpec
      klass = superclass
    end

    klass
  end

  sig { returns(String) }
  def self.target_class_name
    # Get the name of the class under test from the name of the
    # test class
    T.must(spec_test_class.name).gsub(/Spec$/, "")
  end

  sig { params(class_name: String).returns(String) }
  def self.underscore(class_name)
    return class_name unless /[A-Z-]|::/.match?(class_name)

    word = class_name.to_s.gsub("::", "/")
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end

  sig { returns(String) }
  def self.target_class_file
    self.underscore(target_class_name)
  end

  sig {void}
  def before_setup
    self.class.compiler_under_test do
      Object.const_get(self.class.target_class_name)
    end

    self.class.compiler_require(self.class.target_class_file)
  end

  sig { params(str: String, indent: Integer).returns(String) }
  def indented(str, indent)
    str.lines.map! do |line|
      next line if line.chomp.empty?
      " " * indent + line
    end.join
  end

  sig { returns(T::Array[String]) }
  def gathered_constants
    compiler.processable_constants.map { |constant| T.must(constant.name) }.sort
  end

  sig do
    params(
      constant_name: T.any(Symbol, String)
    ).returns(String)
  end
  def rbi_for(constant_name)
    # Make sure this is a constant that we can handle.
    assert_includes(gathered_constants, constant_name.to_s, <<~MSG)
      `#{constant_name}` is not processable by the `#{compiler.name}` generator.
    MSG

    file = RBI::File.new(strictness: "strong")

    constant = Object.const_get(constant_name)

    generators = Tapioca::Reflection.descendants_of(Tapioca::Compilers::Dsl::Base)

    dsl = Tapioca::Compilers::DslCompiler.new(
      requested_constants: [],
      requested_generators: generators
    )

    compiler.new(dsl, file.root, constant).decorate

    file.transformed_string
  end

  sig { returns(T::Array[String]) }
  def generated_errors
    []
    # T.unsafe(self).subject.errors
  end

  sig { void }
  def assert_no_generated_errors
    T.unsafe(self).assert_empty(generated_errors)
  end
end
