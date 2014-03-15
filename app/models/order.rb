#encoding: utf-8
class Order < ActiveRecord::Base
  has_and_belongs_to_many :products
  has_and_belongs_to_many :users
  belongs_to :shop

  validates_presence_of :shop_id, message: "Pian's non renseigne."
  validates_presence_of :total, message: "Total non renseigne."
  validates_numericality_of :total, message: "Total incorrect."

end
