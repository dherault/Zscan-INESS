#encoding: utf-8
class SpecialsController < ApplicationController
  before_action :set_special, only: [:show, :edit, :update, :destroy, :view_shops, :add_shop, :remove_shop]
  before_action :set_shop, only: [:add_shop, :remove_shop]


  # GET /specials
  # GET /specials.json
  def index
    @specials = Special.includes(:shops, :cards).to_a
    @specials.sort! { |a,b| a.name <=> b.name }
  end

  # GET /specials/1
  # GET /specials/1.json
  def show
  end

  # GET /specials/new
  def new
    @special = Special.new
  end

  # GET /specials/1/edit
  def edit
  end

  # POST /specials
  # POST /specials.json
  def create
    @special = Special.new(special_params)

    respond_to do |format|
      if @special.save
        format.html { redirect_to @special, notice: 'Special was successfully created.' }
        format.json { render action: 'show', status: :created, location: @special }
      else
        format.html { render action: 'new' }
        format.json { render json: @special.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /specials/1
  # PATCH/PUT /specials/1.json
  def update
    respond_to do |format|
      if @special.update(special_params)
        format.html { redirect_to @special, notice: 'Special was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @special.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /specials/1
  # DELETE /specials/1.json
  def destroy
    @special.destroy
    respond_to do |format|
      format.html { redirect_to specials_url }
      format.json { head :no_content }
    end
  end

  def view_shops
    @shops = Shop.order(name: :asc).to_a

    respond_to do |format|
      format.html # view_specials.html.erb
      format.json { render json: @special }
    end
  end

  def add_shop
    if @special.shops << @shop
      render json: {status: "success"}
    else
      render json: {status: "error"}
    end
  end

  def remove_shop
    if @special.shops.delete(@shop)
      render json: {status: "success"}
    else
      render json: {status: "error"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_special
      @special = Special.find(params[:id])
    end

    def set_shop
      @shop = Shop.find(params[:shop_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def special_params
      params.require(:special).permit(:name, :description, :function)
    end
end
