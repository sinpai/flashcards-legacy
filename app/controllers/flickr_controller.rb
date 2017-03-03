class FlickrController < ApplicationController
  def index
    @flickr_photos = FlickrGatewayService.new(params[:query]).call
    track_user_used_flickr_load
    render template: 'flickr/index', layout: false
  end
end
