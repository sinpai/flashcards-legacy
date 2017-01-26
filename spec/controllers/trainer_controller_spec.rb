# coding: utf-8
require 'rails_helper'

def check_message(translation, cdate, match)
  put :review_card, params: { card_id: @card.id,
                              user_translation: translation }, xhr: true
  expect(@card.reload.review_date.to_date).to eq(cdate)
  expect((flash[:notice] || flash[:alert])).to match(match)
  expect(response).to redirect_to(trainer_path)
end

RSpec.describe Dashboard::TrainerController do
  before do
    @user = create(:user_with_one_block_and_one_card)
    @controller.send(:auto_login, @user)
    @card = @user.cards.first
  end

  describe 'PUT #review_card' do
    describe 'Corect message is shown' do
      it 'have correct answer' do
        check_message('house', 6.days.from_now.to_date,
                      /Вы ввели верный перевод. Продолжайте.*/)
      end

      it 'have empty answer' do
        check_message('', Date.today,
                      /Вы ввели не верный перевод. Повторите попытку.*/)
      end

      it 'have incorrect answer' do
        check_message('translation', Date.today,
                      /Вы ввели не верный перевод. Повторите попытку.*/)
      end

      it 'have misspelling short' do
        check_message('housy', Date.today,
                      /Вы ввели перевод c опечаткой.*/)
      end
    end
  end
end
