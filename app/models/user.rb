#encoding: utf-8
class User < ActiveRecord::Base
  has_and_belongs_to_many :orders
  has_one :card, as: :scannable, dependent: :destroy

  def name
  	'Client #' + self.id.to_s + ' : ' + self.amount.to_s + '€'
  end
end
