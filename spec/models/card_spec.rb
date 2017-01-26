# coding: utf-8
require 'rails_helper'

def card_errors_check(ortext, trtext, symtext, match)
  card = Card.create(original_text: ortext, translated_text: trtext, user_id: 1,
                     block_id: 1)
  expect(card.errors[symtext]).to include(match)
end

def check_translation_calculation(ortext, trtext, answer, value)
  card = Card.create(original_text: ortext, translated_text: trtext,
                     user_id: 1, block_id: 1)
  check_result = SuperMemo.new(card, answer).check_translation
  expect(check_result).to eq value
end

def check_card_creation_validation(block, sym, match)
  if block.eql?(0)
    card = Card.create(original_text: 'дом', translated_text: 'house',
                       block_id: 1)
  else
    card = Card.create(original_text: 'дом', translated_text: 'house',
                       user_id: 1)
  end
  expect(card.errors[sym]).to include(match)
end

def card_create
  Card.create(original_text: 'дом', translated_text: 'house',
              user_id: 1, block_id: 1)
end

describe Card do
  it 'create card with empty original text' do
    card_errors_check('', 'house', :original_text, 'Необходимо заполнить поле.')
  end

  it 'create card with empty translated text' do
    card_errors_check('дом', '', :translated_text, 'Необходимо заполнить поле.')
  end

  it 'create card with empty texts' do
    card_errors_check('', '', :original_text,
                      'Вводимые значения должны отличаться.')
  end

  it 'equal_texts Eng' do
    card_errors_check('house', 'house', :original_text,
                      'Вводимые значения должны отличаться.')
  end

  it 'equal_texts Rus' do
    card_errors_check('дом', 'дом', :original_text,
                      'Вводимые значения должны отличаться.')
  end

  it 'full_downcase Eng' do
    card_errors_check('hOuse', 'houSe', :original_text,
                      'Вводимые значения должны отличаться.')
  end

  it 'full_downcase Rus' do
    card_errors_check('Дом', 'доМ', :original_text,
                      'Вводимые значения должны отличаться.')
  end

  it 'create card original_text OK' do
    expect(card_create.original_text).to eq('дом')
  end

  it 'create card translated_text OK' do
    expect(card_create.translated_text).to eq('house')
  end

  it 'create card errors OK' do
    expect(card_create.errors.any?).to eq(false)
  end

  it 'set_review_date OK' do
    card = Card.create(original_text: 'дом', translated_text: 'house',
                       user_id: 1, block_id: 1)
    expect(card.review_date.strftime('%Y-%m-%d %H:%M'))
      .to eq(Time.zone.now.strftime('%Y-%m-%d %H:%M'))
  end

  it 'create card witout user_id' do
    check_card_creation_validation(0, :user_id, 'Ошибка ассоциации.')
  end

  it 'create card witout block_id' do
    check_card_creation_validation(1, :block_id,
                                   'Выберите колоду из выпадающего списка.')
  end

  it 'check_translation Eng OK levenshtein_distance=1' do
    check_translation_calculation('дом', 'hou', 'house', 2)
  end

  it 'check_translation Rus OK levenshtein_distance=1' do
    check_translation_calculation('house', 'до', 'дом', 1)
  end
end
