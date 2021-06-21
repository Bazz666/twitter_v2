class Tweet < ApplicationRecord
  belongs_to :user
  accepts_nested_attributes_for :user
  has_many  :likes, dependent: :destroy
  validates :content, presence: true
  acts_as_votable
  has_many :retweets , dependent: :destroy
  
  
  
  scope :tweets_for_me, -> (user_id) { where(user_id: User.find(user_id).friend_list) }
  
  #delegate :profile_photo, to: :user, prefix: :true
  
 
  def self.search_hashs(x)
    @hashs = Tweet.all 
    hash_id_array = [] 
    @hashs.each do |hash|  
        if hash.content.include? "#{x}" 
            hash_id_array << hash.id
        end
    end
    self.where(id: hash_id_array)
  end

  def share
    Tweet.where(origin: self.id).count
  end
end