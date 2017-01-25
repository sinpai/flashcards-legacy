# coding: utf-8
FactoryGirl.define do
  factory :card do
    original_text 'дом'
    translated_text 'house'
    interval 1
    repeat 1
    efactor 2.5
    user
    block
  end
end
