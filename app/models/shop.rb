class Shop < ActiveRecord::Base
  has_secure_password
  has_and_belongs_to_many :products
  has_and_belongs_to_many :specials
  has_many :orders
  has_many :stocks

  validates_presence_of :name, message: "Le nom ne doit pas rester vide."
  validates_presence_of :password, on: :create, message: "Le mot de passe ne doit pas rester vide."
  validates_presence_of :level, message: "Niveau incorrect."
  validates_uniqueness_of :name, message: "Ce nom est deja pris.", case_sensitive: false

end
