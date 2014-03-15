#encoding: utf-8
class PagesController < ApplicationController
  skip_before_action :check_session, only: [:home]
  skip_before_action :check_su

  def home
  end

  def admin_panel
  end

  def checkout
    shop = Shop.find(session[:shop_id])
    @shoporders = shop.orders.includes(users: [:card]).where("total < 0 AND cancelled = ?", false).order(created_at: :desc).limit(5)
    @specials = shop.specials.includes(:cards)
  end

  def checkout_sdt
    shop = Shop.find(session[:shop_id])
    @shoporders = shop.orders.includes(users: [:card]).where("cancelled = ?", false).order(created_at: :desc).limit(5)
    @specials = shop.specials.includes(:cards)
  end

  def saloon
    shop = Shop.find(session[:shop_id])
    @products = shop.products.includes(:cards)
    @specials = shop.specials.includes(:cards)
    @shoporders = shop.orders.includes(:products, users: [:card]).where("total >= 0 AND cancelled = ?", false).order(created_at: :desc).limit(5)
  end

  def simple_stats
    @non_empty_cards = 0
    @users = []
    @shops = Shop.includes(:orders).to_a
    @orders_saloon = Order.includes(:shop).where("total > 0 AND cancelled = ?", false).to_a
    @orders_checkout = Order.includes(:shop).where("total < 0 AND cancelled = ?", false).to_a
    @total_saloon = 0
    @total_checkout = 0
    allusers = User.includes(:orders).to_a


    @orders_checkout.each do |o|
      @total_checkout -= o.total
    end
    @orders_saloon.each do |o|
      @total_saloon += o.total
    end

    allusers.each do |u|
      if u.orders.length > 0
        @users << u
        if u.amount > 0
          @non_empty_cards += 1
        end
      end
    end

    
    end

def stats
    @non_empty_cards = 0
    @users = []
    @shops = Shop.includes(:orders).to_a
    @orders_saloon = Order.includes(:shop).where("total > 0 AND cancelled = ?", false).to_a
    @orders_checkout = Order.includes(:shop).where("total < 0 AND cancelled = ?", false).to_a
    @total_saloon = 0
    @total_checkout = 0
    allusers = User.includes(:orders).to_a


    @orders_checkout.each do |o|
      @total_checkout -= o.total
    end
    @orders_saloon.each do |o|
      @total_saloon += o.total
    end

    allusers.each do |u|
      if u.orders.length > 0
        @users << u
        if u.amount > 0
          @non_empty_cards += 1
        end
      end
    end

    @xml_saloon = ""
    @xml_checkout = ""
    @xml_shops = ""
    @xml_saloon_10min = ""
    @xml_checkout_10min = ""
    xml1 = Builder::XmlMarkup.new(target: @xml_saloon)
    xml2 = Builder::XmlMarkup.new(target: @xml_checkout)
    xml3 = Builder::XmlMarkup.new(target: @xml_shops)
    xml4 = Builder::XmlMarkup.new(target: @xml_saloon_10min)
    xml5 = Builder::XmlMarkup.new(target: @xml_checkout_10min)

    xml1.saloon do 
      @orders_saloon.each do |order|
        xml1.order do
          xml1.shop order.shop.name
          xml1.total order.total
          xml1.time order.created_at
        end
      end
    end
    xml2.checkout do
      @orders_checkout.each do |order|
        xml2.order do
          xml2.shop order.shop.name
          xml2.total order.total
          xml2.time order.created_at
        end
      end
    end
    xml3.shops do
      @shops.each do |shop|
        total_shop_total = 0
        total_shop_orders = 0
        shop.orders.each do |o|
          if o.cancelled == false
            total_shop_total += o.total 
            total_shop_orders += 1
          end
        end
        xml3.shop do
          xml3.name shop.name
          xml3.orders total_shop_orders
          xml3.total total_shop_total
          if total_shop_orders > 0
            xml3.first_order shop.orders.first.created_at
            xml3.last_order shop.orders.last.created_at
          else
            xml3.first_order nil
            xml3.last_order nil
          end
        end
      end
    end
    xml4.saloon_10min do
      start = @orders_saloon.first.created_at
      total_interval = 0
      orders_interval = 0
      @orders_saloon.each do |o|
        if start + 10.minutes >= o.created_at
          total_interval += o.total
          orders_interval += 1
        else
          xml4.interval do
            xml4.start start
            xml4.end start + 10.minutes
            xml4.total total_interval
            xml4.orders orders_interval
          end
          start += 10.minutes
          total_interval = o.total
          orders_interval = 1
        end
      end
    end
    xml5.checkout_10min do
      start = @orders_checkout.first.created_at
      total_interval = 0
      orders_interval = 0
      @orders_checkout.each do |o|
        if start + 10.minutes >= o.created_at
          total_interval += o.total
          orders_interval += 1
        else
          xml5.interval do
            xml5.start start
            xml5.end start + 10.minutes
            xml5.total total_interval
            xml5.orders orders_interval
          end
          start += 10.minutes
          total_interval = o.total
          orders_interval = 1
        end
      end
    end



  end

end
