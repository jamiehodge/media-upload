require_relative "base"

module Media
  module Upload
    module Policies
      class Upload < Base

        def fields
          %w(name resource_id state)
        end
      end
    end
  end
end
