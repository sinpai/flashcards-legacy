# coding: utf-8
require 'rails_helper'
require './app/services/super_memo'

def create_card
  Card.create(original_text: 'dog', translated_text: 'hond', user_id: 1,
                     block_id: 1)
end

def correct_answer
  @card = create_card
  expect(SuperMemo.new(@card, 'hond').card_update).to be true
end

def incorrect_answer
  @card = create_card
  expect(SuperMemo.new(@card, '123asd123asd').card_update).to be nil
end

def mistyped_answer
  @card = create_card
  expect(SuperMemo.new(@card, 'hont').card_update).to be false
end

def distance_calc(answer, value)
  card = create_card
  expect(SuperMemo.new(card, answer).check_translation).to eq(value)
end

describe SuperMemo do
  it 'should correctly change efactor when correct answer' do
    correct_answer
    expect(@card.reload.efactor.round(1)).to eq(2.6)
  end
  it 'should correctly change efactor when incorrect answer' do
    incorrect_answer
    expect(@card.reload.efactor.round(1)).to eq(1.7)
  end
  it 'should correctly change efactor when it lower than minimum' do
    mistyped_answer
    expect(@card.reload.efactor.round(1)).to eq(2.5)
  end
  it 'should correctly change interval when correct answer' do
    correct_answer
    expect(@card.reload.interval).to eq(1)
  end
  it 'should correctly change interval when 2 correct answers' do
    card = create_card
    studied = SuperMemo.new(card, 'hond')
    expect(2.times { studied.card_update }).to be 2
    expect(card.interval).to eq(6)
  end
  it 'should correctly change interval when incorrect answer' do
    incorrect_answer
    expect(@card.reload.interval).to eq(1)
  end
  it 'should correctly change interval when mistyping' do
    mistyped_answer
    expect(@card.reload.interval).to eq(1)
  end
  it 'should correctly change interval when first correct attempt' do
    correct_answer
    expect(@card.reload.interval).to eq(1)
  end
  it 'should correctly change interval when third correct attempt' do
    card = create_card
    studied = SuperMemo.new(card, 'hond')
    expect(3.times { studied.card_update }).to be 3
    expect(card.reload.interval).to eq(17)
  end
  it 'should correctly change repeat when correct answer' do
    correct_answer
    expect(@card.reload.repeat).to eq(2)
  end
  it 'should correctly change repeat when incorrect answer' do
    incorrect_answer
    expect(@card.reload.repeat).to eq(1)
  end
  it 'should correctly change repeat when mistyping' do
    mistyped_answer
    expect(@card.reload.repeat).to eq(2)
  end
  it 'should correctly change repeat when mistyping for 2 chars' do
    card = create_card
    expect(SuperMemo.new(card, 'homt').card_update).to be nil
    expect(card.reload.repeat).to eq(2)
  end
  it 'should correctly calculate quality for distance 0' do
    distance_calc('hond', 0)
  end
  it 'should correctly calculate quality for distance 3' do
    distance_calc('hamt', 3)
  end
  it 'should correctly calculate quality for distance 5' do
    distance_calc('hondation', 5)
  end
  it 'should correctly set review_date when correct answer' do
    correct_answer
    expect(@card.review_date.to_date).to eq(1.day.from_now.to_date)
  end
  it 'should correctly set review_date when 4 correct answers made' do
    card = create_card
    studied = SuperMemo.new(card, 'hond')
    4.times { studied.card_update }
    expect(card.review_date.to_date).to eq(49.day.from_now.to_date)
  end
  it 'should correctly set review_date when incorrect answer' do
    incorrect_answer
    expect(@card.review_date.to_date).to eq(Date.today)
  end
  it 'should correctly set review_date when incorrect answer' do
    mistyped_answer
    expect(@card.review_date.to_date).to eq(Date.today)
  end
  it 'should correctly get check status when correct answer' do
    correct_answer
  end
  it 'should correctly get check status when incorrect answer' do
    incorrect_answer
  end
  it 'should correctly get check status when mistyping exists' do
    mistyped_answer
  end
end
