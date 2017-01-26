# coding: utf-8
require 'rails_helper'

def distance_calc(answer, value)
  expect(SuperMemo.new(create_card, answer).check_translation).to eq(value)
end

describe SuperMemo do

  let(:create_card) {Card.create(original_text: 'dog', translated_text: 'hond', user_id: 1, block_id: 1)}
  let(:correct_answer) {expect(SuperMemo.new(@card = create_card, 'hond').card_update).to be true}
  let(:incorrect_answer) {expect(SuperMemo.new(@card = create_card, '123asd123asd').card_update).to be nil}
  let(:mistyped_answer) {expect(SuperMemo.new(@card = create_card, 'hont').card_update).to be false}

  describe 'correct cases' do

    before(:each) { correct_answer }

    it 'should correctly change efactor when correct answer' do
      expect(@card.reload.efactor.round(1)).to eq(2.6)
    end

    it 'should correctly change interval when correct answer' do
      expect(@card.reload.interval).to eq(1)
    end

    it 'should correctly change interval when first correct attempt' do
      expect(@card.reload.interval).to eq(1)
    end

    it 'should correctly change repeat when correct answer' do
      expect(@card.reload.repeat).to eq(2)
    end

    it 'should correctly set review_date when correct answer' do
      expect(@card.review_date.to_date).to eq(1.day.from_now.to_date)
    end
  end

  describe 'incorrect cases' do

    before(:each) { incorrect_answer }

    it 'should correctly change efactor when incorrect answer' do
      expect(@card.reload.efactor.round(1)).to eq(1.7)
    end

    it 'should correctly change interval when incorrect answer' do
      expect(@card.reload.interval).to eq(1)
    end

    it 'should correctly change repeat when incorrect answer' do
      expect(@card.reload.repeat).to eq(1)
    end

    it 'should correctly set review_date when incorrect answer' do
      expect(@card.review_date.to_date).to eq(Date.today)
    end
  end

  describe 'mistyped cases' do

    before(:each) { mistyped_answer }

    it 'should correctly change efactor when there was mistyping' do
      expect(@card.reload.efactor.round(1)).to eq(2.5)
    end

    it 'should correctly change interval when mistyping' do
      expect(@card.reload.interval).to eq(1)
    end

    it 'should correctly change repeat when mistyping' do
      expect(@card.reload.repeat).to eq(2)
    end

    it 'should correctly set review_date when incorrect answer' do
      expect(@card.review_date.to_date).to eq(Date.today)
    end
  end

  describe 'distance_check_cases' do

    it 'should correctly calculate quality for distance 0' do
      distance_calc('hond', 0)
    end

    it 'should correctly calculate quality for distance 3' do
      distance_calc('hamt', 3)
    end

    it 'should correctly calculate quality for distance 5' do
      distance_calc('hondation', 5)
    end

  end

  describe 'common cases' do

    describe 'with card' do

      before(:each) { @card = create_card }

      describe 'with correct answer' do

        before(:each) { @studied = SuperMemo.new(@card, 'hond') }

        it 'should correctly change interval when 2 correct answers' do
          expect(2.times { @studied.card_update }).to be 2
          expect(@card.interval).to eq(6)
        end

        it 'should correctly change interval when third correct attempt' do
          expect(3.times { @studied.card_update }).to be 3
          expect(@card.reload.interval).to eq(17)
        end

        it 'should correctly set review_date when 4 correct answers made' do
          4.times { @studied.card_update }
          expect(@card.review_date.to_date).to eq(49.day.from_now.to_date)
        end

      end

      it 'should correctly change repeat when mistyping for 2 chars' do
        expect(SuperMemo.new(@card, 'homt').card_update).to be nil
        expect(@card.reload.repeat).to eq(2)
      end

      it 'should correctly change efactor when it lower than minimum' do
        @card.update_attributes(efactor: 1.1)
        SuperMemo.new(@card, 'hond').card_update
        expect(@card.reload.efactor.round(1)).to eq(1.3)
      end
    end
  end
end
