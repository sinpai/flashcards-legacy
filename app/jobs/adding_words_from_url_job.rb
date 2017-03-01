class AddingWordsFromUrlJob < ApplicationJob
  queue_as :default

  def perform(current_user, params)
    WordsFromUrlService.new(current_user, params).parse
  end
end
