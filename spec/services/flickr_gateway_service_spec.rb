require 'rails_helper'

RSpec.describe FlickrGatewayService do

  describe 'get photos list' do
    it 'returns 12 images' do
      VCR.use_cassette('flickr/load_images') do
        photos = FlickrGatewayService.new('unicorn').photos_list

        expect(photos.size).to eq(12)
      end
    end

    it 'returns grouped images by 3 grid rows' do
      VCR.use_cassette('flickr/grouped_images') do
        flickr = FlickrGatewayService.new('unicorn').call

        expect(flickr.size).to eq(3)
      end
    end
  end
end
