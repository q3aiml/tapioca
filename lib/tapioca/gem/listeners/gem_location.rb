# typed: strict
# frozen_string_literal: true

module Tapioca
  module Gem
    module Listeners
      class GemLocation < Base
        extend T::Sig

        private

        sig { override.params(event: ConstNodeAdded).void }
        def on_const(event)
          file, line = Object.const_source_location(event.symbol)
          add_gem_location_comment(event.node, file, line)
        end

        sig { override.params(event: ScopeNodeAdded).void }
        def on_scope(event)
          file, line = Object.const_source_location(event.symbol)
          add_gem_location_comment(event.node, file, line)
        end

        sig { override.params(event: MethodNodeAdded).void }
        def on_method(event)
          # puts event.node.name
          # file, line = Object.const_source_location(event.constant)
        end

        sig do
          params(
            node: RBI::NodeWithComments,
            file: T.nilable(String),
            line: T.nilable(Integer),
          ).void
        end
        def add_gem_location_comment(node, file, line)
          return unless file && line

          gem = @pipeline.gem

          path = Pathname.new(file)
          relative_path = path.relative_path_from(gem.full_gem_path)

          node.comments << RBI::Comment.new("gem://#{gem.name}@#{gem.version}/#{relative_path}:#{line}")
        end
      end
    end
  end
end
