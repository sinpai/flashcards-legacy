class FlickrGatewayService
  attr_reader :query, :per_page, :flickr

  PER_PAGE = 12

  def initialize(query, per_page = PER_PAGE)
    @query = query
    @per_page = per_page

    @flickr = FlickRaw::Flickr.new(
      api_key: Rails.application.secrets.flickr_api_key,
      shared_secret: Rails.application.secrets.flickr_secret
    )
  end

  def photos_list
    Rails.cache.fetch("#{query}/#{per_page}", expires_in: 12.hours, race_condition_ttl: 30) do
      flickr.photos.search(text: query, per_page: per_page)
    end
  end

  def call
    photos_list.each_slice(4)
  end
end
