#encoding: utf-8
class Stock < ActiveRecord::Base
  belongs_to :shop
  belongs_to :product

  validates_presence_of :qty
  validates_presence_of :shop_id
  validates_presence_of :product_id
  validates_numericality_of :qty
end
