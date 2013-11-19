require_relative "base"

module Media
  module Upload
    module Presenters
      class Upload < Base

        def etag
          Digest::MD5.hexdigest([item.id, item.lock_version, parts_presenter.etag].join("-"))
        end

        private

        def parts_presenter
          Base.create(context, item.parts)
        end
      end
    end
  end
end
