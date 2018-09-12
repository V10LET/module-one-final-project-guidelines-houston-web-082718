class CreateFriend < ActiveRecord::Migration[5.0]
  def change
    create_table :friends do |t|
      t.string :name
      t.integer :snowman_id
    end
  end
end
