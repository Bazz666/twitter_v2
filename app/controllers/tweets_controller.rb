class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[ show edit update destroy retweets]
  before_action :authenticate_user!, exept: [:index,:show]
  skip_before_action :verify_authenticity_token, :only => [:index, :show,:new ]
  # GET /tweets or /tweets.json

 

  def upvote 
    @tweet = Tweet.find(params[:id])
    @tweet.upvote_by current_user
    redirect_to tweets_path
  end  
  
  def downvote
    @tweet = Tweet.find(params[:id])
    @tweet.downvote_by current_user
    redirect_to tweets_path
  end

  def view_Like
    @tweet = Tweet.find(params[:id])
    @tweet.upvote_by current_user
    respond_to do |format|
      # format.html { redirect_to root_url, alert: 'Page not accessible' }
      format.html { redirect_to tweets_likes_path}
      format.json { render :likes, status: :created, location: @tweet }
    end
    
  end  


  def retweet

    if current_user
      @tweet = Tweet.find(params[:tweet_id])
      Tweet.create(content: @tweet.content , user_id: current_user.id, origin: @tweet.id)
    end
    redirect_to root_path
  end


  def index
    @q = Tweet.ransack(params[:q])

    
    if params[:tweetsearch].present?
      @tweets = Tweet.search_my_tweets(params[:tweetsearch]).page(params[:page]).order("created_at DESC")
    elsif params[:hashtag].present?
      @tweets = Tweet.search_my_tweets("##{params[:hashtag]}").page(params[:page]).order("created_at DESC")
    end

    if user_signed_in?
      @tweet = current_user.tweets.build
      @tweets =@q.result(distinct: true).tweets_for_me(current_user).paginate(page: params[:page], per_page: 5)
      #@tweets = Tweet.paginate(page: params[:page], per_page: 5)
     
      @likes = Like.all
      @retweet = Retweet.all
      @tweet = Tweet.new
    else
      @tweets=(@q.result(distinct: true)).all
    end
    return @tweets, @tweet

  end


  # GET /tweets/1 or /tweets/1.json
  def show
    @users = []
    @tweet = Tweet.find(params[:id])
    @tweet.likes.each do |like|
      @users.push(User.find(like.user_id))
    end
    return @tweet, @users
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
    @users = User.pluck :profile_photo, :id, :username, :profile_photo
    
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets or /tweets.json
  def create
    @tweet = Tweet.new(tweet_params.merge(user: current_user))
    @tweet.user_id = current_user.id
    respond_to do |format|
      if @tweet.save
        format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /tweets/1 or /tweets/1.json
  def update
    if @tweet.user.id == current_user.id
      respond_to do |format|
        if @tweet.update(tweet_params)
          format.html { redirect_to @tweet, notice: "Tweet was successfully updated." }
          format.json { render :show, status: :ok, location: @tweet }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @tweet.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to tweets_path, notice: 'Only admins or the user who created the story can update'
    end
  end

  # DELETE /tweets/1 or /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: "Tweet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end
    

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:content, :retweet ,:origin, user_attributes: [:username , :profile_photo])
    end
end