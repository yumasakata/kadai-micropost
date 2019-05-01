class User < ApplicationRecord

  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }    
    has_secure_password
    
    has_many :microposts
    has_many :relationships
    has_many :following_users, through: :relationships, source: :follow
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverses_of_relationship, source: :user
    
   def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
      relationship = self.relationships.find_by(follow_id: other_user.id)
      relationship.destroy if relationship
  end

  def following?(other_user)
      self.following_users.include?(other_user)
  end
  
  has_many :likes
  has_many :like_posts, through: :likes, source: :micropost

  def like(micropost)
      self.likes.find_or_create_by(micropost_id: micropost.id)
  end

  def unlike(micropost)
    like = self.likes.find_by(micropost_id: micropost.id)
    like.destroy if like
  end
  
  def like?(micropost)  #お気に入り済みか？
    self.like_posts.include?(micropost)
  end
end
