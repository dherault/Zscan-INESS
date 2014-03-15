class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.integer :qty
      t.integer :shop_id
      t.integer :product_id

      t.timestamps
    end
  end
end
