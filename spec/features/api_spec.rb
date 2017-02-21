# coding: utf-8
require 'rails_helper'
require 'support/helpers/api_helper.rb'
include ApiHelper

describe ApiFlashcards::HomeController, type: :controller do
  context 'GET #index' do
    it 'gets index successfully' do
      basic_auth 'admin@example.com', 'password'
      visit '/api'
      expect(response.status).to eq 200
    end
  end
end
