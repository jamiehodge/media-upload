require "media/client"
require "media/queue"
require "tempfile"
require "fileutils"

require_relative "../models"

module Media
  module Upload
    module Tasks
      class Concatenation
        extend Queueable

        attr_reader :id, :model, :resourcer, :storer

        def initialize(params = {})
          @id        = params.fetch(:id)
          @model     = params.fetch(:model) { Models::Upload }
          @resourcer = params.fetch(:resourcer) { Client::Service::Resource.new(["RESOURCE_URL"]) }
          @storer    = params.fetch(:storer)    { Client::Service::Storage.new(["STORAGE_URL"]) }
        end

        def call
          Tempfile.open([upload.basename, upload.extension]) do |temp|
            upload.concatenating!

            upload.parts.map(&:file).each do |file|
              temp << file.read(4096) until file.eof?
            end

            temp.rewind

            file = storer.create(file: temp)

            if file.success?
              upload.db.transaction do
                upload.update(file_id: file.body[:id])
                resourcer.update(upload.resource_id, file_id: file.body[:id])
              end

              upload.concatenated!
            else
              upload.failed!
            end
          end
        rescue => e
          self.class.logger.error("#{e.message} (#{e.class}): #{e.backtrace.join("\n")}")
          upload.failed!
        end

        private

        def upload
          @upload ||= model[id]
        end
      end
    end
  end
end
