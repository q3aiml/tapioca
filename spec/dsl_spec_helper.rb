# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require "minitest/spec"
require "tapioca/helpers/test/dsl_plugin"

class DslSpec < Minitest::Spec
  extend T::Sig
  include Kernel
  include Tapioca::Helpers::Test::DslPlugin

  before do
    # Require the file that the target class should be loaded from
    require self.class.target_class_file
    use_plugin(Object.const_get(self.class.target_class_name))
  end

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

  sig { params(str: String, indent: Integer).returns(String) }
  def indented(str, indent)
    str.lines.map! do |line|
      next line if line.chomp.empty?
      " " * indent + line
    end.join
  end

  sig { void }
  def assert_no_generated_errors
    T.unsafe(self).assert_empty(generated_errors)
  end
end
