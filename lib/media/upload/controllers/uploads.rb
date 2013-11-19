require_relative "base"
require_relative "../tasks"

module Media
  module Upload
    module Controllers
      class Uploads < Base

        set(:model)     { Models::Upload }
        set(:policy)    { Policies::Upload }
        set(:presenter) { Presenters::Upload }

        crud
      end
    end
  end
end
