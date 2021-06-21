class Tweet < ApplicationRecord
  belongs_to :user
  accepts_nested_attributes_for :user
  has_many  :likes, dependent: :destroy
  validates :content, presence: true
  acts_as_votable
  has_many :retweets , dependent: :destroy
  
  
  scope :tweets_for_me, -> (user) { Tweet.where(user_id: user.friends.pluck(:friend_id).uniq) }
  
  
  #delegate :profile_photo, to: :user, prefix: :true
  
 
  def self.search_posts(x)
    @posts = Tweet.all 
    posts_id_array = [] 
    @posts.each do |post|  
        if post.content.include? "#{x}" 
            post_id_array << post.id
        end
    end
    self.where(id: post_id_array)
  end

  def share
    Tweet.where(origin: self.id).count
  end
end