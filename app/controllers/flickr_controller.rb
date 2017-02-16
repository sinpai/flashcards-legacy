class FlickrController < ApplicationController
  def index
    @flickr_photos = FlickrGatewayService.new(params[:query]).call

    render template: 'flickr/index', layout: false
  end
end
