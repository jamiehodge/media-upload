require_relative "../lib/media/upload"

module Media
  Persistence::DB.transaction do

    %w(pending completed concatenating concatenated failed).each do |name|
      Upload::Models::State.find_or_create(name: name)
    end
  end
end
