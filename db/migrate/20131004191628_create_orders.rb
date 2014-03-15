class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :shop_id
      t.float :total
      t.boolean :cancelled, default: false

      t.timestamps
    end
  end
end
