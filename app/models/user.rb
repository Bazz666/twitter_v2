class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tweets , dependent: :destroy
  has_many :likes , dependent: :destroy
  has_many :friends, dependent: :destroy
  
 

  
  def to_s
    username
  end

  

  

  def suggest_friends
    current_friends_id = self.friends.map{|f| f.friend_id}
    current_friends_id.push(self.id)
    @suggest = User.where.not(id: current_friends_id)
  end

  def follow?(user)
    return (friends.where('friend_id=?', user).count == 1)
  end

  
 

end