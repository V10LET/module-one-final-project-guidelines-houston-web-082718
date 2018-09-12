class CreateGift < ActiveRecord::Migration[5.0]
  def change
    create_table :gifts do |t|
      t.string :name
      t.float :price
      t.integer :snowman_id
    end
  end
end
