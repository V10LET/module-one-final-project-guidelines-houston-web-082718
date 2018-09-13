class Friend < ActiveRecord::Base
  has_many :friend_gifts
  has_many :gifts, through: :friend_gifts
  belongs_to :snowman
end
