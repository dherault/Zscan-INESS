#encoding: utf-8
class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]
  skip_before_action :check_su, only: [:read, :transfer]

  # GET /cards
  # GET /cards.json
  def index
    @cards = Card.includes(:scannable).to_a
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = Card.new(card_params)

    respond_to do |format|
      if @card.save
        format.html { redirect_to @card, notice: 'Card was successfully created.' }
        format.json { render action: 'show', status: :created, location: @card }
      else
        format.html { render action: 'new' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url }
      format.json { head :no_content }
    end
  end

  def before_assign
    @products = Product.includes(:cards).to_a
    @specials = Special.includes(:cards).to_a
  end

  def assign
    if params[:scannable_id].blank? || params[:scannable_type].blank? || params[:uid].blank?
      render json: {status: 'error', message: "try harder"}
    else 
      card = Card.includes(:scannable).find_by uid: params[:uid]
      if card
        render json: {status: 'success', card: card.scannable.name}
      else
        card = Card.new()
        card.with_lock do
          if params[:scannable_type] != "User"
            card.scannable_type = params[:scannable_type]
            card.scannable_id = params[:scannable_id]
            card.uid = params[:uid]
          else
            user = User.new(amount: 0.00)
            user.with_lock do
              if user.save!
                card = Card.new(scannable_type: params[:scannable_type], scannable_id: user.id, uid: params[:uid])
              else
                render json: {status: 'error', message: "DB error while user save"}
              end
            end
          end
          if card.save!
            render json: {status: 'success', scannable: card.scannable.name}
          else
            render json: {status: 'error', message: "DB error while card save"}
          end
        end
      end
    end
  end

  def before_read
  end

  def read
    if params[:uid].blank?
      render json: {status: 'error', message: "try harder"}
    else
      card = Card.includes(:scannable).find_by uid: params[:uid]
      if card
        render json: {status: 'success', name: card.scannable.name}
      else
        render json: {status: 'error'}
      end
    end
  end

  def transfer
    if params[:uid1].blank? || params[:uid2].blank?
      render json: {status: 'error', message: "try harder"}
    else
      card1 = Card.includes(:scannable).find_by uid: params[:uid1]
      card2 = Card.includes(:scannable).find_by uid: params[:uid2]
      if card1 && card1.scannable_type = "User"
        user1 = card1.scannable
        if card2 && card1.scannable_type = "User"
          user2 = card2.scannable
          if user2.update_attribute(:amount, user1.amount + user2.amount) && user1.update_attribute(:amount, 0)
            render json: {status: 'success', amount: user2.amount}
          else
            render json: {status: 'error', message: "La transaction a échouée"}
          end
        else
          render json: {status: 'error', message: "Deuxième client introuvable"}
        end
      else
        render json: {status: 'error', message: "Premier client introuvable"}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:scannable_id, :scannable_type, :uid)
    end
end
