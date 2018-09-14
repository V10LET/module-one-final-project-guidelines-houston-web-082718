class Snowman < ActiveRecord::Base
  has_many :gifts, dependent: :destroy
  has_many :friends, dependent: :destroy
  has_many :friend_gifts, dependent: :destroy

end
