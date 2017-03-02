class AddingWordsFromUrlJob < ApplicationJob
  queue_as :default

  def perform(current_user, block_id, params)
    WordsFromUrlService.new(current_user, block_id, params).parse
  end
end
