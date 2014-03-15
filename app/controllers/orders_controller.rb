#encoding: utf-8
class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  skip_before_action :check_su, only: [:save_checkout, :save_checkout_sdt, :save_saloon, :cancel_order]


  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.includes(:shop, :products, users: [:card]).where("cancelled = ?", false).order(created_at: :desc).to_a
    @cancelled_orders = Order.includes(:shop, :products, users: [:card]).where("cancelled = ?", true).order(created_at: :desc).to_a
    @total_saloon = 0
    @total_checkout = 0
    @orders.each do |order|
      if order.total >= 0
        @total_saloon += order.total
      else
        @total_checkout -= order.total
      end
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  def save_checkout
    if params[:user_id].blank? || params[:addedAmount].blank?
      render json: {status: 'error', data: "try harder"}
    else
      user = User.find(params[:user_id])
      if user
        if params[:addedAmount].to_s =~ /^-?(\d+(\.\d+)?|\.\d+)$/
          addedAmount = (params[:addedAmount].to_f * 100.00).round / 100.00
          if addedAmount >= 0
            order = Order.new(total: -addedAmount, shop_id: session[:shop_id])
            if order.save
              if order.users << user
                if user.update_attribute(:amount, user.amount + addedAmount)
                  render json: {status: "success", data: "Carte rechargée", :id => order.id}
                else
                  order.destroy
                  render json: {status: "error", data: "Erreur lors de la mise à jour du client, veuillez réessayer"} and return
                end
              else
                order.destroy
                render json: {status: "error", data: "Erreur lors de la création du lien HABTM, veuillez réessayer"} and return
              end
            else
              render json: {status: "error", data: "Erreur lors de la création de la conso, veuillez réessayer"} and return
            end
          else
              render json: {status: "error", data: "Le montant ne doit pas être négatif"} and return
          end
        else
          render json: {status: "error", data: "Montant incorrect"} and return
        end
      else
        render json: {status: "error", data: "Client introuvable"} and return
      end
    end
  end
  def save_checkout_sdt
    if params[:uid].blank?
      render json: {status: 'error', data: "try harder"}
    else
      card = Card.includes(:scannable).find_by uid: params[:uid]
      if card
        if card.scannable_type == "User"
          user = card.scannable
          lastamount = user.amount
          order = Order.new(total: lastamount, shop_id: session[:shop_id])
          if order.save
            if order.users << user
              if user.update_attribute(:amount, 0)
                render json: {status: "success", data: lastamount, :id => order.id}
              else
                order.destroy
                render json: {status: "error", data: "Erreur lors de la mise à jour du client, veuillez réessayer"} and return
              end
            else
              order.destroy
              render json: {status: "error", data: "Erreur lors de la création du lien HABTM, veuillez réessayer"} and return
            end
          else
            render json: {status: "error", data: "Erreur lors de la création de la conso, veuillez réessayer"} and return
          end
        else
          render json: {status: "error", data: "Pas une carte client"} and return
        end
      else
        render json: {status: "error", data: "Carte introuvable"} and return
      end
    end
  end

  def save_saloon
    if params[:users].blank? || params[:products].blank? || params[:total].blank?
      render json: {status: 'error', data: "try harder"}
    else 
      if params[:total].to_s =~ /^-?(\d+(\.\d+)?|\.\d+)$/
        users = params[:users]
        products = ActiveSupport::JSON.decode(params[:products])
        total = (params[:total].to_f * 100).round / 100.0
        total_per_user = total / users.length
        user_position = 1
        all_users = []
        order = Order.new(shop_id: session[:shop_id], cancelled: false, total: total)
        if order.save
          users.each do |user_uid|
            card = Card.includes(:scannable).find_by uid: user_uid
            if card
              if card.scannable_type == "User"
                user = card.scannable
                if user.amount >= total
                  all_users << user
                  if order.users << user
                  else
                    order.destroy
                    render json: {status: "error", data: "Echec de la sauvegarde de la commande (user)"} and return
                  end
                else
                  order.destroy
                  if users.length == 1
                    render json: {status: "error", data: "Pas assez de crédit : " + user.amount.to_s + "€ < " + total_per_user.to_s + "€"} and return
                  else
                    render json: {status: "error", data: "Le client "+ user_position + " n'a pas assez de crédit : " + user.amount.to_s + "€ < " + total_per_user.to_s + "€"} and return
                  end
                end
              else
                order.destroy
                if users.length == 1
                  render json: {status: "error", data: "Client introuvable"} and return
                else
                  render json: {status: "error", data: "Client " + user_position.to_s + " introuvable"} and return
                end
              end
            else
              order.destroy
              if users.length == 1
                render json: {status: "error", data: "Carte introuvable"} and return
              else
                render json: {status: "error", data: "Carte " + user_position.to_s + " introuvable"} and return
              end
            end
            user_position += 1
          end
          products.each do |product|
            a_product = Product.find(product["id"])
            product["qte"].times do
              if order.products << a_product
              else
                order.destroy
                render json: {status: "error", data: "Echec de la sauvegarde de la commande (products)"} and return
              end
            end
          end
          new_amount = ""
          all_users.each do |user|
            user.update_attribute(:amount, user.amount - total_per_user)
            new_amount += user.amount.to_s + " "
          end
          render json: {status: "success", amount: new_amount, id: order.id} and return
        else
          render json: {status: "error", data: "Echec de la sauvegarde de la commande"} and return
        end
      else
        render json: {status: "error", data: "Montant incorrect"} and return
      end
    end
  end

  def cancel_order
    if params[:order_id].blank?
      render json: {status: 'error', data: "try harder"}
    else
      order = Order.includes(:users).find(params[:order_id])
      if order
        users = order.users
        users.each do |user|
          # mauvais code
          user.update_attribute(:amount, user.amount + order.total/users.length)
        end
        if order.update_attribute(:cancelled, true)
          render json: {status: "success"}
        else
          render json: {status: "error", data: "Echec de la MAJ de la commande"}
        end
      else
        render json: {status: "error", data: "Commande introuvable"}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:shop_id, :total, :cancelled)
    end
end
