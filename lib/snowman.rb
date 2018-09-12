class Snowman < ActiveRecord::Base
  has_many :gifts
  has_many :friends
end
