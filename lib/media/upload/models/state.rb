require_relative "base"

module Media
  module Upload
    module Models
      class State < Base
        one_to_many :uploads

        PENDING       = first(name: "pending")
        COMPLETED     = first(name: "completed")
        CONCATENATING = first(name: "concatenating")
        CONCATENATED  = first(name: "concatenated")
        FAILED        = first(name: "failed")
      end
    end
  end
end
