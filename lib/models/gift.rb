class Gift < ActiveRecord::Base
  has_many :friend_gifts
  has_many :friends, through: :friend_gifts
  belongs_to :snowman
end
