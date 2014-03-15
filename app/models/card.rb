#encoding: utf-8
class Card < ActiveRecord::Base
  belongs_to :scannable, polymorphic: true
end
