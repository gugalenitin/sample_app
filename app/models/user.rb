  class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_secure_password
  
  has_many :microposts, dependent: :destroy
  # Since there is no column with name user_id in the relationships table,
  # we need to explicitely tell rails which is the foreign_key here
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  # source: :followed is actually the belongs_to in relationship.rb
  # No need of source if we give name as :followeds instead of :followed_users
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships,  foreign_key: "followed_id",
                                    dependent: :destroy,
                                    class_name: "Relationship"
  # We can ommit the use of source here
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def following?(other_user)
    self.relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    self.relationships.find_by_followed_id(other_user.id).destroy
  end

  def feed
    # This is only a prototype-feed.
    # Micropost.where("user_id = #{ self.id }").
    # Use below version of code. Using it in string is not recommended
    # Use this: Micropost.where("user_id = ?", self.id)
    # self.microposts

    Micropost.from_users_followed_by(self)
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
