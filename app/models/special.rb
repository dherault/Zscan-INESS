#encoding: utf-8
class Special < ActiveRecord::Base
  has_many :cards, as: :scannable, dependent: :destroy
  has_and_belongs_to_many :shops
  
  validates_presence_of :name, message: "Le nom ne doit pas rester vide."
  validates_presence_of :function, message: "La fonction ne doit pas rester vide."
  validates_uniqueness_of :name, message: "Ce nom est deja pris."
end
