class Tweet < ApplicationRecord
  belongs_to :user
  accepts_nested_attributes_for :user
  has_many  :likes, dependent: :destroy
  validates :content, presence: true
  acts_as_votable
  has_many :retweets , dependent: :destroy
  
  
  scope :tweets_for_me, -> (user) { Tweet.where(user_id: user.friends.pluck(:friend_id).uniq) }
  
  
  #delegate :profile_photo, to: :user, prefix: :true
  
 
  def self.search_my_tweets(x)
    @my_tweets = Tweet.all 
    my_tweet_id_array = [] 
    @my_tweets.each do |my_tweet|  
        if my_tweet.content.include? "#{x}" 
            my_tweet_id_array << my_tweet.id
        end
    end
    self.where(id: my_tweet_id_array)
  end

  def share
    Tweet.where(origin: self.id).count
  end
end