class ApiController < ApplicationController
    include ActionController::HttpAuthentication::Basic::ControllerMethods

    skip_before_action :verify_authenticity_token, on: [:create]
    http_basic_authenticate_with name: "pepa@example.com", password: "123456", except: [:news, :tweets_range]

    def news
    @info = []
    @tweets = Tweet.all.last(50)
    @tweets.each do |tweet|
        @info << {
        :id => tweet.id,
        :content => tweet.content,
        :user_id => tweet.user_id,
        :likes_count => tweet.likes.count,
        :retweets_count => tweet.retweets,
        :retweeted_from => tweet.origint
    }

    end
    render json: @info.reverse, status: :ok
    end

    def tweets_range
    start_date = DateTime.parse(params[:fecha1]).beginning_of_day
    end_date = DateTime.parse(params[:fecha2]).end_of_day
    @tweets = Tweet.where("created_at >= ? AND created_at <= ?", start_date, end_date)
        if @tweets != nil
            render json: @tweets, status: :ok
        else
            render json: [], status: :no_content
        end
    end

    def create
    data = JSON.parse(request.body.read)["content"]
    user_email = JSON.parse(request.body.read)["user"]
    @user = User.find_by(email: user_email)
    @tweet = Tweet.create(content: data, user_id: @user.id, parent_tweet: nil, content_retweet: nil)

        if @tweet.save
            render json: @tweet, status: :ok
        else
            render json: "Error en creacion, del tweet", status: :internal_server_error
        end
    end
end
