class AddParentToProducts < ActiveRecord::Migration
  def change
    add_column :products, :parent_id, :integer, :default => 0
    add_column :products, :parent_qty, :float, :default => 0
  end
end
