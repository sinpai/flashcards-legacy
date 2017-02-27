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

module ApiFlashcards::Api::V1
  describe CardsController, type: :controller do
    let!(:user) { create(:user) }
    routes { ApiFlashcards::Engine.routes }

    context "Not authenticated access" do
      describe "Get cards#index" do
        it "has a 401 status code" do
          get :index
          expect(response.status).to eq(401)
        end
      end

      describe "Post cards#create" do
        it "has a 401 status code" do
          post :create
          expect(response.status).to eq(401)
        end
      end
    end

    # TODO There is a problem with basic auth with rspec and sorcery's method. It needs to be figured out, why it gives 401.
    # context "Authenticated access" do
    #   before(:each) { basic_auth user.email, '12345' }

    #   describe "Get cards#index" do
    #     it "has a 200 status code" do
    #       visit 'api/v1/cards'
    #       expect(response.status).to eq(200)
    #     end
    #   end

    #   describe "POST cards#create" do
    #     let(:params) do
    #         { card:
    #           {
    #             original_text: 'Test',
    #             translated_text: 'Тест',
    #             block_id: 1
    #           }
    #         }
    #     end
    #     it "has a 201 status code" do
    #       visit 'api/v1/cards'
    #       byebug
    #       post :create, params
    #       expect(response.status).to eq(201)
    #     end
    #   end
    # end
  end

  describe TrainerController, type: :controller do
    let!(:user) { create(:user_with_one_block_and_one_card) }
    routes { ApiFlashcards::Engine.routes }

    context "Not authenticated access" do
      describe "Get trainer#index" do
        it "has a 401 status code" do
          get :index
          expect(response.status).to eq(401)
        end
      end
    end

    # TODO There is a problem with basic auth with rspec and sorcery's method. It needs to be figured out, why it gives 401.
    # context "Authenticated access" do
    #   before { basic_auth user.email, '12345' }

    #   describe "GET traner#index" do
    #     it "has a 200 status code" do
    #       get :index
    #       expect(response.status).to eq(200)
    #     end
    #   end

    #   describe "PUT review_card with wrong translation" do
    #     it "check translation" do
    #       put :review_card, user_translation: "sun", card_id: user.cards.first.id
    #       parse_json = JSON(response.body)
    #       expect(parse_json["message"]).to eq(t(:incorrect_translation_alert))
    #     end
    #   end

    #   describe "PUT review_card with correct translation" do
    #     it "check translation" do
    #       put :review_card, user_translation: "Дот", card_id: user.cards.first.id
    #       parse_json = JSON(response.body)
    #       expect(parse_json["message"]).to eq(t(:translation_from_misprint_alert))
    #     end
    #   end

    #   describe "PUT review_card with correct translation" do
    #     it "check translation" do
    #       put :review_card, user_translation: "Дом", card_id: user.cards.first.id
    #       parse_json = JSON(response.body)
    #       expect(parse_json["message"]).to eq(t(:correct_translation_notice))
    #     end
    #   end
    # end
  end
end

