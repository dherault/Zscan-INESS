class CreateSpecials < ActiveRecord::Migration
  def change
    create_table :specials do |t|
      t.string :name
      t.string :description
      t.string :function

      t.timestamps
    end
  end
end
