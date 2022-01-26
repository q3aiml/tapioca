# typed: true
# frozen_string_literal: true

require "tapioca/helpers/test/content"
require "tapioca/helpers/test/isolation"
require "tapioca/helpers/test/template"

module Tapioca::Helpers::Test::DslPlugin
  extend T::Sig
  extend T::Helpers

  include Tapioca::Helpers::Test::Isolation
  include Tapioca::Helpers::Test::Content
  include Tapioca::Helpers::Test::Template

  requires_ancestor { Kernel }

  sig { params(plugin_class: T.class_of(Tapioca::Compilers::Dsl::Base)).returns(Context) }
  def use_plugin(plugin_class)
    @context = Context.new(plugin_class)
  end

  sig { params(plugin_classes: T.class_of(Tapioca::Compilers::Dsl::Base)).void }
  def activate_other_plugins(*plugin_classes)
    context.activate_other_plugins(plugin_classes)
  end

  sig { params(constant_name: T.any(String, Symbol)).returns(String) }
  def rbi_for(constant_name)
    context.rbi_for(constant_name)
  end

  sig { returns(T::Array[String]) }
  def gathered_constants
    context.gathered_constants
  end

  sig { returns(T::Array[String]) }
  def generated_errors
    context.errors
  end

  sig { returns(Context) }
  def context
    raise "Please call `plugin_under_test` before" unless @context
    @context
  end

  class Context
    extend T::Sig

    sig { returns(T.class_of(Tapioca::Compilers::Dsl::Base)) }
    attr_reader :plugin_class

    sig { returns(T::Array[T.class_of(Tapioca::Compilers::Dsl::Base)]) }
    attr_reader :other_plugin_classes

    sig { returns(T::Array[String]) }
    attr_reader :errors

    def initialize(plugin_class)
      @plugin_class = plugin_class
      @other_plugin_classes = []
      @errors = []
    end

    sig { params(plugin_classes: T::Array[T.class_of(Tapioca::Compilers::Dsl::Base)]).void }
    def activate_other_plugins(plugin_classes)
      @other_plugin_classes = plugin_classes
    end

    def activated_plugin_classes
      [plugin_class, *other_plugin_classes]
    end

    sig { returns(T::Array[String]) }
    def gathered_constants
      plugin_class.gather_constants.map(&:name).compact.sort
    end

    sig { params(constant_name: T.any(String, Symbol)).returns(String) }
    def rbi_for(constant_name)
      # Make sure this is a constant that we can handle.
      unless gathered_constants.include?(constant_name.to_s)
        raise "`#{constant_name}` is not processable by the `#{plugin_class.name}` generator."
      end

      constant = Object.const_get(constant_name) # rubocop:disable Sorbet/ConstantsFromStrings

      file = RBI::File.new(strictness: "strong")

      dsl = Tapioca::Compilers::DslCompiler.new(
        requested_constants: [],
        requested_generators: activated_plugin_classes
      )
      plugin = plugin_class.new(dsl, file.root, constant)
      plugin.decorate
      @errors = plugin.errors

      file.transformed_string
    end
  end
end
