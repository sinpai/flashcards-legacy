# Algorithm SM-2 used in the computer-based variant of the SuperMemo method and
# involving the calculation of easiness factors for particular items:
# http://www.supermemo.com/english/ol/sm2.htm

# Service for card check and setting new interval for card review
class SuperMemo
  def initialize(card, answer)
    @card = card
    @answer = answer
  end

  def card_update
    quality = get_quality(check_translation)
    efactor = set_efactor(@card.efactor, quality)
    repeat = quality >= 3 ? (@card.repeat + 1) : 1
    interval = set_interval(repeat, efactor)
    number_of = quality == 5 ? interval : 0
    @card.update_attributes(interval: interval,
                            efactor: efactor,
                            repeat: repeat,
                            review_date: number_of.days.from_now)
    get_check_status(quality)
  end

  def get_check_status(quality)
    @card.translated_text == @answer ? true : (quality >= 4 ? false : nil)
  end

  def check_translation
    Levenshtein.distance(full_downcase(@card.translated_text),
                         full_downcase(@answer))
  end

  def set_interval(repeat, efactor)
    case repeat
    when 1 then 1
    when 2 then 6
    else (@card.interval * efactor).round
    end
  end

  def set_efactor(efactor, quality)
    new_efactor = efactor + (0.1 - (5 - quality) *
                                   (0.08 + (5 - quality) * 0.02))
    new_efactor < 1.3 ? 1.3 : new_efactor
  end

  def get_quality(distance = nil)
    case distance
    when 0 then 5
    when 0..1 then 4
    when 1..2 then 3
    when 2..3 then 2
    when 3..4 then 1
    else 0
    end
  end

  def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end
end
