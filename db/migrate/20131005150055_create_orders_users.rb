class CreateOrdersUsers< ActiveRecord::Migration
  def self.up
    create_table :orders_users, :id => false do |t|
        t.references :order
        t.references :user
    end
    add_index :orders_users, [:order_id, :user_id]
  end

  def self.down
    drop_table :orders_users
  end
end
