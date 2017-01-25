class Dashboard::TrainerController < Dashboard::BaseController

  respond_to :html, :js

  def index
    if params[:id]
      @card = current_user.cards.find(params[:id])
    else
      if current_user.current_block
        @card = current_user.current_block.cards.pending.first
      else
        @card = current_user.cards.pending.first
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def review_card
    @card = current_user.cards.find(params[:card_id])

    @oncheck = SuperMemo.new(@card, trainer_params[:user_translation])
    @oncheck.card_update
    if @card.translated_text == trainer_params[:user_translation]
      flash[:notice] = t(:correct_translation_notice)
    elsif (0.01..0.33).include? @oncheck.check_translation.round(2)
        flash[:alert] = t 'translation_from_misprint_alert',
                          user_translation: trainer_params[:user_translation],
                          original_text: @card.original_text,
                          translated_text: @card.translated_text
    else
      flash[:alert] = t(:incorrect_translation_alert)
    end
    redirect_to trainer_path
  end

  private

  def trainer_params
    params.permit(:user_translation, :utf8, :_method, :commit, :card_id, :locale)
  end
end
