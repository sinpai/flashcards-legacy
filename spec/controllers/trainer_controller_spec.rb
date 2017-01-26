# coding: utf-8
require 'rails_helper'

RSpec.describe Dashboard::TrainerController do
  before do
    @user = create(:user_with_one_block_and_one_card)
    @controller.send(:auto_login, @user)
    @card = @user.cards.first
  end

  describe 'PUT #review_card' do
    describe 'Corect message is shown' do
      it 'have correct answer' do
        put :review_card, params: { card_id: @card.id, user_translation: 'house' }, xhr: true
        expect(@card.reload.review_date.to_date).to eq(Date.today + 6)
        expect(flash[:notice]).to match(/Вы ввели верный перевод. Продолжайте.*/)
        expect(response).to redirect_to(trainer_path)
      end

      it 'have empty answer' do
        put :review_card, params: { card_id: @card.id, user_translation: '' }, xhr: true
        expect(@card.reload.review_date.to_date).to eq(Date.today)
        expect(flash[:alert]).to match(/Вы ввели не верный перевод. Повторите попытку.*/)
        expect(response).to redirect_to(trainer_path)
      end

      it 'have incorrect answer' do
        put :review_card, params: { card_id: @card.id, user_translation: 'translation' }, xhr: true
        expect(@card.reload.review_date.to_date).to eq(Date.today)
        expect(flash[:alert]).to match(/Вы ввели не верный перевод. Повторите попытку.*/)
        expect(response).to redirect_to(trainer_path)
      end

      it 'have misspelling short' do
        put :review_card, params: { card_id: @card.id, user_translation: 'housy' }, xhr: true
        expect(@card.reload.review_date.to_date).to eq(Date.today)
        expect(flash[:alert]).to match(/Вы ввели перевод c опечаткой.*/)
        expect(response).to redirect_to(trainer_path)
      end
    end
  end
end
