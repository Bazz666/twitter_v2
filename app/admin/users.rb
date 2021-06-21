ActiveAdmin.register User do

  permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :username, :profile_photo
  
  actions :all

  index do

    column "name" do |post|
      post.username
    end
    column "Likes" do |post|
      post.likes.count
    end
    column "Tweets" do |post|
      post.tweets.count
    end
    column "Retweets" do |post|
      post.tweets.count
    end
    column "Follows" do |post|
      post.friends.count
    end
    
    actions
  end
end
