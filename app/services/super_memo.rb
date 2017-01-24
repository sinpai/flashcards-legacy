# Algorithm SM-2 used in the computer-based variant of the SuperMemo method and
# involving the calculation of easiness factors for particular items:
# http://www.supermemo.com/english/ol/sm2.htm

class SuperMemo

  def initialize(card, answer)
    @card = card
    @answer = answer
  end

  def card_update
    quality = set_quality(check_translation)
    efactor = set_efactor(@card.efactor, quality)
    repeat = quality >= 3 ? (@card.repeat + 1) : 1
    interval = set_interval(repeat, efactor)
    @card.update_attributes(interval: interval, efactor: efactor, repeat: repeat, review_date: interval.days.from_now)
  end

  def check_translation
    Levenshtein.normalized_distance(full_downcase(@card.translated_text),
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
    efactor = efactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
    efactor < 1.3 ? 1.3 : efactor
  end

  def set_quality(distance = 1)
    case distance
    when 0 then 5
    when 0..0.25 then 4
    when 0.26..0.5 then 3
    when 0.51..0.75 then 2
    when 0.76..0.99 then 1
    else 0
    end
  end

  def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end
end
