# coding: utf-8
FactoryGirl.define do
  factory :card do
    original_text 'дом'
    translated_text 'house'
    user
    block
  end
end
