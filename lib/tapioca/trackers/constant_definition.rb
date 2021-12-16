# typed: true
# frozen_string_literal: true

require "set"

module Tapioca
  module Trackers
    # Registers a TracePoint immediately upon load to track points at which
    # classes and modules are opened for definition. This is used to track
    # correspondence between classes/modules and files, as this information isn't
    # available in the ruby runtime without extra accounting.
    module ConstantDefinition
      extend Reflection

      @class_files = {}.compare_by_identity

      # Immediately activated upon load. Observes class/module definition.
      TracePoint.trace(:class, :c_return) do |tp|
        case tp.event
        when :class
          next if tp.self.singleton_class?

          key = tp.self
          @class_files[key] ||= Set.new
          @class_files[key] << required_from_location
        when :c_return
          next unless tp.method_id == :new
          next unless Module === tp.return_value

          key = tp.return_value
          @class_files[key] ||= Set.new
          @class_files[key] << required_from_location
        end
      end

      # Returns the files in which this class or module was opened. Doesn't know
      # about situations where the class was opened prior to +require+ing,
      # or where metaprogramming was used via +eval+, etc.
      def self.files_for(klass)
        if String === klass
          klass = constantize(klass)
        end

        files = @class_files[klass]
        files || Set.new
      end
    end
  end
end
