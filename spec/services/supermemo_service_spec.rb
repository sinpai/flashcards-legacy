# coding: utf-8
require 'rails_helper'

def distance_calc(answer, value)
  expect(SuperMemo.new(create_card, answer).check_translation).to eq(value)
end

describe SuperMemo do

  let(:create_card) {Card.create(original_text: 'dog', translated_text: 'hond', user_id: 1, block_id: 1)}

  before(:each) { create_card }

  describe 'correct cases' do

    let(:correct_answer) { SuperMemo.new(create_card, 'hond').card_update }
    before(:each) { correct_answer }

    it 'should return correct state' do
      expect(correct_answer).to be true
    end

    it 'should correctly change efactor when correct answer' do
      expect(create_card.reload.efactor.round(1)).to eq(2.6)
    end

    it 'should correctly change interval when correct answer' do
      expect(create_card.reload.interval).to eq(1)
    end

    it 'should correctly change interval when first correct attempt' do
      expect(create_card.reload.interval).to eq(1)
    end

    it 'should correctly change repeat when correct answer' do
      expect(create_card.reload.repeat).to eq(2)
    end

    it 'should correctly set review_date when correct answer' do
      expect(create_card.review_date.to_date).to eq(1.day.from_now.to_date)
    end
  end

  describe 'incorrect cases' do

    let(:incorrect_answer) { SuperMemo.new(create_card, '123asd123asd').card_update }
    before(:each) { incorrect_answer }

    it 'should return correct state when invalid answer' do
      expect(incorrect_answer).to be nil
    end

    it 'should correctly change efactor when incorrect answer' do
      expect(create_card.reload.efactor.round(1)).to eq(1.7)
    end

    it 'should correctly change interval when incorrect answer' do
      expect(create_card.reload.interval).to eq(1)
    end

    it 'should correctly change repeat when incorrect answer' do
      expect(create_card.reload.repeat).to eq(1)
    end

    it 'should correctly set review_date when incorrect answer' do
      expect(create_card.review_date.to_date).to eq(Date.today)
    end
  end

  describe 'mistyped cases' do

    let(:mistyped_answer) { SuperMemo.new(create_card, 'hont').card_update }
    before(:each) { mistyped_answer }

    it 'should return correct state when mistype' do
      expect(mistyped_answer).to be false
    end

    it 'should correctly change efactor when there was mistyping' do
      expect(create_card.reload.efactor.round(1)).to eq(2.5)
    end

    it 'should correctly change interval when mistyping' do
      expect(create_card.reload.interval).to eq(1)
    end

    it 'should correctly change repeat when mistyping' do
      expect(create_card.reload.repeat).to eq(2)
    end

    it 'should correctly set review_date when incorrect answer' do
      expect(create_card.review_date.to_date).to eq(Date.today)
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

      describe 'with correct answer' do

        let(:studied) { SuperMemo.new(create_card, 'hond') }

        it 'should correctly change interval when 2 correct answers' do
          expect(2.times { studied.card_update }).to be 2
          expect(create_card.interval).to eq(6)
        end

        it 'should correctly change interval when third correct attempt' do
          expect(3.times { studied.card_update }).to be 3
          expect(create_card.reload.interval).to eq(17)
        end

        it 'should correctly set review_date when 4 correct answers made' do
          4.times { studied.card_update }
          expect(create_card.review_date.to_date).to eq(49.day.from_now.to_date)
        end

        it 'should correctly change efactor when it lower than minimum' do
          create_card.update_attributes(efactor: 1.1)
          studied.card_update
          expect(create_card.reload.efactor.round(1)).to eq(1.3)
        end

      end

      it 'should correctly change repeat when mistyping for 2 chars' do
        expect(SuperMemo.new(create_card, 'homt').card_update).to be nil
        expect(create_card.reload.repeat).to eq(2)
      end

    end
  end
end
