require_relative "base"

module Media
  module Upload
    module Controllers
      class Parts < Base

        set(:model)  { Models::Part }
        set(:policy) { Policies::Part }

        crud
      end
    end
  end
end
