class FriendGift < ActiveRecord::Base
  belongs_to :friend
  belongs_to :gift
  belongs_to :snowman
end
