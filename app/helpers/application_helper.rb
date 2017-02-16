module ApplicationHelper
  def flickr_image_url(item)
    farm = "farm#{item['farm']}"
    server_id = item['server']
    photo_id = item['id']
    secret = item['secret']
    size = "m"

    "https://#{farm}.staticflickr.com/#{server_id}/#{photo_id}_#{secret}_#{size}.jpg"
  end
end
