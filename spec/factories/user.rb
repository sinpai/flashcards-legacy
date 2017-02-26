FactoryGirl.define do
  to_create do |instance|
    unless instance.save
      raise "Invalid record: " + instance.errors.full_messages.join(", ")
    end
  end

  sequence(:email) { |n| "test#{n * Time.now.to_i}@test.com" }

  factory :user do
    email
    password '12345'
    password_confirmation '12345'
    locale 'ru'
    current_block_id ''

    factory :user_with_one_block_without_cards do
      after(:create) do |user|
        create(:block, user: user)
      end
    end

    factory :user_with_two_blocks_without_cards do
      after(:create) do |user|
        2.times { create(:block, user: user) }
      end
    end

    factory :user_with_one_block_and_one_card do
      after(:create) do |user|
        create(:block_with_one_card, user: user)
      end
    end

    factory :user_with_one_block_and_two_cards do
      after(:create) do |user|
        create(:block_with_two_cards, user: user)
      end
    end

    factory :user_with_two_blocks_and_one_card_in_each do
      after(:create) do |user|
        2.times { create(:block_with_one_card, user: user) }
      end
    end

    factory :user_with_two_blocks_and_only_one_card do
      after(:create) do |user|
        create(:block, user: user)
        create(:block_with_one_card, user: user)
      end
    end

    factory :user_with_two_blocks_and_two_cards_in_each do
      after(:create) do |user|
        2.times { create(:block_with_two_cards, user: user) }
      end
    end
  end
end
