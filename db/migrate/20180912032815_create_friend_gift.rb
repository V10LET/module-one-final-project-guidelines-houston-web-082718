class CreateFriendGift < ActiveRecord::Migration[5.0]
  def change
    create_table :friend_gifts do |t|
      t.integer :friend_id
      t.integer :gift_id
    end
  end
end
