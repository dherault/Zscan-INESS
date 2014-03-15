#encoding: utf-8
class Product < ActiveRecord::Base
  has_and_belongs_to_many :shops
  has_and_belongs_to_many :orders
  has_many :stocks
  has_many :cards, as: :scannable, dependent: :destroy
  has_many :children, class_name: "Product", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Product"

  validates_presence_of :name, message: "Le nom ne doit pas rester vide."
  validates_presence_of :price, message: "Le prix ne doit pas rester vide."
  validates_uniqueness_of :name, message: "Ce nom est deja pris."
  validates_numericality_of :price, message: "Prix incorrect."
end
