require_relative "base"

module Media
  module Upload
    module Policies
      class Part < Base

        def fields
          %w(file position upload_id)
        end
      end
    end
  end
end
