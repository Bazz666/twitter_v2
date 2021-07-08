class ApiController < ApplicationController
    include ActionController::HttpAuthentication::Basic::ControllerMethods

    skip_before_action :verify_authenticity_token, on: [:create]
    http_basic_authenticate_with name: "postman@example.com", password: "postman", only: [:create]

    def news
        @info = []
        @tweets = Tweet.all.last(50)
        @tweets.each do |tweet|
            @info << {
            :id => tweet.id,
            :content => tweet.content,
            :user_id => tweet.user_id,
            :likes_count => tweet.likes.count,
            :retweets_count => tweet.retweets.count,
            :retweeted_from => tweet.origin
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
        @tweet = Tweet.new(content: request.headers["content"], user_id: request.headers["user"])
        
        if @tweet.save
            render json: @tweet, status: :created
        else
            render json: @tweet.errors, status: :unprocessable_entity
        end
    end
end
