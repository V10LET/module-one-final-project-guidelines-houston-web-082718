class Snowman < ActiveRecord::Base
  has_many :gifts
  has_many :friends
  has_many :friend_gifts
end
