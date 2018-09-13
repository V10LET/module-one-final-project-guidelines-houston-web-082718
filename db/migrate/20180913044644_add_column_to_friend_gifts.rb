class AddColumnToFriendGifts < ActiveRecord::Migration[5.0]
  def change
    add_column :friend_gifts, :snowman_id, :integer
  end
end
