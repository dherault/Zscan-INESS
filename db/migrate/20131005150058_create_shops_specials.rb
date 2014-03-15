class CreateShopsSpecials < ActiveRecord::Migration
  def self.up
    create_table :shops_specials, :id => false do |t|
        t.references :shop
        t.references :special
    end
    add_index :shops_specials, [:shop_id, :special_id]
  end

  def self.down
    drop_table :shops_specials
  end
end
