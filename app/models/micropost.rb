class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  default_scope order: 'microposts.created_at DESC'

  def self.from_users_followed_by(user)
    # following_ids = user.followed_users.map(&:id)
    # following_ids = user.followed_user_ids
    # where("user_id IN (?) OR user_id = ?", following_ids, user.id)
    following_ids_query = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("user_id IN (#{following_ids_query}) OR user_id = :user_id", user_id: user.id)
  end
end
