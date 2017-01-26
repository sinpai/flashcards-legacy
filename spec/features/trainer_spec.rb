# coding: utf-8
require 'rails_helper'
require 'support/helpers/login_helper.rb'
include LoginHelper

def create_with_review_date(arg)
  user = create(arg)
  user.cards.each { |card| card.update_attribute(:review_date,
                                                 Time.now - 3.days) }
  visit trainer_path
  login('test@test.com', '12345', 'Войти')
end

def create_and_set_block(arg)
  user = create(arg)
  block = user.blocks.first
  user.set_current_block(block)
  card = user.cards.find_by(block_id: block.id)
  card.update_attribute(:review_date, Time.now - 3.days)
  visit trainer_path
  login('test@test.com', '12345', 'Войти')
end

def training_without_cards(arg)
  create(arg)
  visit trainer_path
  login('test@test.com', '12345', 'Войти')
  expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
end

describe 'review cards without blocks' do
  describe 'training without cards' do
    before do
      training_without_cards(:user)
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end
end

describe 'review cards with one block' do
  describe 'training without cards for one and two block' do
    it 'no cards' do
      %i(user_with_one_block_without_cards
         user_with_two_blocks_without_cards).each do |arg|
        training_without_cards(arg)
      end
    end
  end

  describe 'training with two cards' do
    before do
      create_with_review_date(:user_with_one_block_and_two_cards)
    end

    it 'first visit' do
      expect(page).to have_content 'Оригинал'
    end

    it 'incorrect translation' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation' do
      fill_in 'user_translation', with: 'house'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели верный перевод. Продолжайте.'
    end

    it 'correct translation distance=1' do
      fill_in 'user_translation', with: 'hous'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели перевод c опечаткой.'
    end

    it 'incorrect translation distance=2' do
      fill_in 'user_translation', with: 'hou'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end
  end

  describe 'training with one card' do
    before do
      create_with_review_date(:user_with_one_block_and_one_card)
    end

    it 'incorrect translation' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation' do
      fill_in 'user_translation', with: 'house'
      click_button 'Проверить'
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end

    it 'incorrect translation distance=2' do
      fill_in 'user_translation', with: 'hou'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation distance=1' do
      fill_in 'user_translation', with: 'hous'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели перевод c опечаткой.'
    end
  end
end

describe 'review cards with two blocks' do

  describe 'training with two cards' do
    before do
      create_with_review_date(:user_with_two_blocks_and_one_card_in_each)
    end

    it 'first visit' do
      expect(page).to have_content 'Оригинал'
    end

    it 'incorrect translation' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation' do
      fill_in 'user_translation', with: 'house'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели верный перевод. Продолжайте.'
    end

    it 'incorrect translation distance=2' do
      fill_in 'user_translation', with: 'hou'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation distance=1' do
      fill_in 'user_translation', with: 'hous'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели перевод c опечаткой.'
    end
  end

  describe 'training with one card' do
    before do
      create_with_review_date(:user_with_two_blocks_and_only_one_card)
    end

    it 'incorrect translation' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation' do
      fill_in 'user_translation', with: 'house'
      click_button 'Проверить'
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end

    it 'incorrect translation distance=2' do
      fill_in 'user_translation', with: 'hou'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation distance=1' do
      fill_in 'user_translation', with: 'hous'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели перевод c опечаткой.'
    end
  end
end

describe 'review cards with current_block' do
  describe 'training without cards' do
    before do
      create(:user_with_two_blocks_without_cards, current_block_id: 1)
      visit trainer_path
      login('test@test.com', '12345', 'Войти')
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end

  describe 'training with two cards' do
    before do
      create_and_set_block(:user_with_two_blocks_and_two_cards_in_each)
    end

    it 'first visit' do
      expect(page).to have_content 'Оригинал'
    end

    it 'incorrect translation' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation' do
      fill_in 'user_translation', with: 'house'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели верный перевод. Продолжайте.'
    end

    it 'incorrect translation distance=2' do
      fill_in 'user_translation', with: 'hou'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation distance=1' do
      fill_in 'user_translation', with: 'hous'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели перевод c опечаткой.'
    end
  end

  describe 'training with one card' do
    before do
      create_and_set_block(:user_with_two_blocks_and_one_card_in_each)
    end

    it 'incorrect translation' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation' do
      fill_in 'user_translation', with: 'house'
      click_button 'Проверить'
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end

    it 'incorrect translation distance=2' do
      fill_in 'user_translation', with: 'hou'
      click_button 'Проверить'
      expect(page).
          to have_content 'Вы ввели не верный перевод. Повторите попытку.'
    end

    it 'correct translation distance=1' do
      fill_in 'user_translation', with: 'hous'
      click_button 'Проверить'
      expect(page).to have_content 'Вы ввели перевод c опечаткой.'
    end
  end
end
