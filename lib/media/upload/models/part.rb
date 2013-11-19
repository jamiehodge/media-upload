require_relative "base"

module Media
  module Upload
    module Models
      class Part < Base
        many_to_one :upload

        plugin :list, scope: :upload_id

        storable

        def extension
          position
        end

        def before_validation
          self.position ||= last_position + 1
          super
        end

        def validate
          super
          validates_uuid [:upload_id]
        end
      end
    end
  end
end
