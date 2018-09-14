class Friend < ActiveRecord::Base
  has_many :friend_gifts, dependent: :destroy
  has_many :gifts, through: :friend_gifts, dependent: :destroy
  belongs_to :snowman
end
