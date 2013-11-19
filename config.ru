require "./lib/media/upload"

Media::Upload::Controllers::Base.children.each do |child|
  map "/%s" % child.namespace do
    run child
  end
end
