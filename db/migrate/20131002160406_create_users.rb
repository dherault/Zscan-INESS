class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.float :amount, default: 0.00
      t.timestamps
    end
  end
end
