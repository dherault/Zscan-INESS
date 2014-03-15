#encoding: utf-8
class ShopsController < ApplicationController
  before_action :set_shop, only: [:show, :edit, :update, :destroy, :view_products, :add_product, :remove_product, :view_specials, :add_special, :remove_special]
  before_action :set_product, only: [:add_product, :remove_product]
  before_action :set_special, only: [:add_special, :remove_special]
  skip_before_action :check_session, only: [:login, :before_login, :quick_start]
  skip_before_action :check_su, only: [:login, :before_login, :quick_start, :logout]

  # GET /shops
  # GET /shops.json
  def index
    @shops = Shop.order(level: :desc).to_a
  end

  # GET /shops/1
  # GET /shops/1.json
  def show
  end

  # GET /shops/new
  def new
    @shop = Shop.new
  end

  # GET /shops/1/edit
  def edit
  end

  # POST /shops
  # POST /shops.json
  def create
    @shop = Shop.new(shop_params)

    respond_to do |format|
      if @shop.save
        format.html { redirect_to shops_path, success: 'Shop was successfully created.' }
      else
        format.html { render action: 'new' }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shops/1
  # PATCH/PUT /shops/1.json
  def update
    respond_to do |format|
      if @shop.update(shop_params)
        format.html { redirect_to shops_path, success: 'Shop was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.json
  def destroy
    @shop.destroy
    respond_to do |format|
      format.html { redirect_to shops_url }
      format.json { head :no_content }
    end
  end

  def view_products
    @products = Product.order(name: :asc).to_a
  end

  def add_product
    if @shop.products << @product
      render json: {status: "success"}
    else
      render json: {status: "error"}
    end
  end

  def remove_product
    if @shop.products.delete(@product)
      render json: {status: "success"}
    else
      render json: {status: "error"}
    end
  end

  def view_specials
    @specials = Special.order(name: :asc).to_a
  end

  def add_special
    if @shop.specials << @special
      render json: {status: "success"}
    else
      render json: {status: "error"}
    end
  end

  def remove_special
    if @shop.specials.delete(@special)
      render json: {status: "success"}
    else
      render json: {status: "error"}
    end
  end

  def before_login
  end

  def login
    shop = Shop.find_by name: params[:name]
    if shop && shop.authenticate(params[:password])
      session[:shop_id]    = shop.id
      session[:shop_level] = shop.level
      session[:shop_name]  = shop.name
      if session[:return_to]
        redirect_to session[:return_to], success: "Connexion réussie"
      else
        case shop.level
          when 1
              redirect_to saloon_path, success: "Connexion réussie"
          when 2
              redirect_to checkout_path, success: "Connexion réussie"
          when 3
              redirect_to checkout_sdt_path, success: "Connexion réussie"
          when 4
              redirect_to stocks_dashboard_path, success: "Connexion réussie"
          when 5
              redirect_to simple_stats_path, success: "Connexion réussie"
          when 6
              redirect_to chatter_path, success: "Connexion réussie"
          when 7
              redirect_to chatter_path, success: "Connexion réussie"
          else
            redirect_to root_path, success: "Connexion réussie"
        end
      end
    else
      redirect_to before_login_path, error: "Identifiants incorrect"
    end
  end

  def logout
    session[:shop_id]    = nil
    session[:shop_level] = nil
    session[:shop_name]  = nil
    session[:return_to]  = nil
    redirect_to root_url, success: "Déconnexion réussie"
  end

  def quick_start
    ztphp = Shop.all.to_a
    if ztphp.blank?
      hztphp = Shop.new()
      hztphp.name = "ztphp"
      hztphp.password = "111"
      hztphp.password_confirmation = hztphp.password
      hztphp.level = 10
      if hztphp.save
        redirect_to root_path, success: "Call it, friendo"
      else
        redirect_to root_path, error: "Heads"
      end
    else
      redirect_to root_path, error: "Nothing happens"
    end
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_special
      @special = Special.find(params[:special_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shop_params
      params.require(:shop).permit(:name, :level, :description, :password, :password_confirmation)
    end
end
