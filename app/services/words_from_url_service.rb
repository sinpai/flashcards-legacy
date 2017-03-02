# coding: utf-8
class WordsFromUrlService
  attr_accessor :errors, :words
  attr_reader :node, :params, :user_id

  def initialize(user_id, block_id, params)
    @user_id = user_id
    @block_id = block_id
    @params = params
    @errors = []
    @words = []
    @node = parse_resourse
  end

  def parse
    if node.kind_of? Nokogiri::HTML::Document
      byebug
      node.search(params[:row_element]).each do |row|
        original_text   = row.search(params[:original_text_element].strip).first
        translated_text = row.search(params[:translated_text_element].strip).first
        create_card!(original_text, translated_text)
      end
      send_report_mail!
    else
      errors << { msg: 'node is not Nokogiri object!' }
    end
  end

  def parse_resourse
    Nokogiri::HTML(open(params[:url]))
  rescue => e
    errors << { msg: e.to_s }
  end

  def create_card!(original_text, translated_text)
    if original_text && translated_text
      card = Card.new(
        original_text: first_downcase_word(original_text),
        translated_text: first_downcase_word(translated_text),
        user_id: user_id,
        block_id: block_id
      )

      if card.valid?
        card.save!
        words << { original: card.original_text, translated: translated_text }
      end
    end
  end

  def send_report_mail!
    CardsMailer.parsed_cards_notification(user_id, words, errors).deliver_later
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
