#encoding: utf-8
class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :view_shops, :add_shop, :remove_shop]
  before_action :set_shop, only: [:add_shop, :remove_shop]


  # GET /products
  # GET /products.json
  def index
    @products = Product.includes(:shops, :cards).to_a
    @products.sort! { |a,b| a.name <=> b.name }

  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to products_url, success: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to products_url, success: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  def view_shops
    @shops = Shop.order(name: :asc).to_a

    respond_to do |format|
      format.html # view_products.html.erb
      format.json { render json: @product }
    end
  end

  def add_shop
    if @product.shops << @shop
      render json: {status: "success"}
    else
      render json: {status: "error"}
    end
  end

  def remove_shop
    if @product.shops.delete(@shop)
      render json: {status: "success"}
    else
      render json: {status: "error"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def set_shop
      @shop = Shop.find(params[:shop_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :parent_id, :parent_qty)
    end
end
