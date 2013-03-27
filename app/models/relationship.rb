class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  # Since there are no models with names follower and followed,
  # we need to explicitely tell rils about the class to use
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  validates :followed_id, presence: true
  validates :follower_id, presence: true
end
