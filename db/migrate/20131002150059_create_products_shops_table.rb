class CreateProductsShopsTable < ActiveRecord::Migration
  def self.up
    create_table :products_shops, :id => false do |t|
        t.references :product
        t.references :shop
    end
    add_index :products_shops, [:product_id, :shop_id]
  end

  def self.down
    drop_table :products_shops
  end
end
