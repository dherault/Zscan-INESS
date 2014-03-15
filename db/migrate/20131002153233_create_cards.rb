class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :scannable_id
      t.string :scannable_type
      t.string :uid

      t.timestamps
    end
  end
end
