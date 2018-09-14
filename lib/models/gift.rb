class Gift < ActiveRecord::Base
  has_many :friend_gifts, dependent: :destroy
  has_many :friends, through: :friend_gifts, dependent: :destroy
  belongs_to :snowman
end
