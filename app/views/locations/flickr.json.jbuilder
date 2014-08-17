json.flickr do
  json.array! @search do |photo|
    json.id photo.id
    json.url FlickRaw.url_b(photo)
  end
end

json.set! :page, @page

