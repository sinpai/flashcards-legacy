class Dashboard::CardsController < Dashboard::BaseController
  before_action :set_card, only: [:destroy, :edit, :update]

  def index
    @cards = current_user.cards.all.order('review_date')
  end

  def new
    @card = Card.new
  end

  def edit
  end

  def parse_form
  end

  def parse_words
    AddingWordsFromUrlJob.perform_later(@current_user.id, parse_words_params.to_h)
    redirect_to cards_path, notice: t(:words_parsing)
  end

  def create
    @card = current_user.cards.build(card_params)
    if @card.save
      redirect_to cards_path
    else
      respond_with @card
    end
  end

  def update
    if @card.update(card_params)
      redirect_to cards_path
    else
      respond_with @card
    end
  end

  def destroy
    @card.destroy
    respond_with @card
  end

  private

  def set_card
    @card = current_user.cards.find(params[:id])
  end

  def parse_words_params
    params.require(:parse_form).permit(:original_text_element, :translated_text_element, :url, :row_element)
  end

  def parse_params_hash
    parse_words_params.to_h.merge! Hash.new(block_id: current_user.blocks.first)
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date,
                                 :image, :image_cache, :remove_image, :block_id, :user_id, :remote_image_url)
  end
end
