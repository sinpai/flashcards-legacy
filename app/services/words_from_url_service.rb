# coding: utf-8
class WordsFromUrlService
  attr_accessor :errors, :words
  attr_reader :node, :params, :user_id, :block_id

  def initialize(user_id, params)
    @user_id = user_id
    @block_id = block_id
    @params = params
    @errors = []
    @words = []
    @node = parse_resourse(params[:url])
  end

  def parse
    node.search(params[:search_xpath]).each do |row|
      original_text   = row.search(params[:original_text_selector].strip).first
      translated_text = row.search(params[:translated_text_selector].strip).first

      create_card!(original_text, translated_text)
    end

    send_report_mail!
  end

  def parse_resourse(url)
    Nokogiri::HTML(open(url))
  rescue => e
    @errors << { msg: e.to_s }
  end

  def create_card!(original_text, translated_text)
    if original_text && translated_text
      card = Card.new(
        original_text: first_downcase_word(original_text),
        translated_text: first_downcase_word(translated_text),
        user_id: user_id,
        block_id: 1
      )

      if card.valid?
        card.save!
        words << { original: card.original_text, translated: translated_text }
      end
    end
  end

  def send_report_mail!
    CardsMailer.parsed_cards_notification(user_id, words, errors).deliver_now
  end

  def fix_encoding(text)
    begin
      text.encode("ISO-8859-1").force_encoding('UTF-8')
    rescue Encoding::UndefinedConversionError
      @errors << { msg: I18n.t('wrong_encoding_msg') }
    rescue => e
      @errors << { msg: e.to_s }
    end
  end

  def first_downcase_word(text)
    word = text.try(:downcase)

    begin
      word.match("([a-zA-Zа-яА-Я]+)")[0] if word
    rescue
      fix_encoding(text).match("([a-zA-Zа-яА-Я]+)")[0]
    end
  end
end
