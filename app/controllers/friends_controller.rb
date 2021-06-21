class FriendsController < ApplicationController
    before_action :set_friend, only: %i[ show edit update destroy ]
   
   
  
  
    # GET /friends or /friends.json
    def index
      
      @friends = Friend.all
    end
  
    # GET /friends/1 or /friends/1.json
    def show
  
      
      @friends= Friend.all
      
      
    end
  
    # GET /friends/new
    def new
      @friend = Friend.new
    end
  
    # GET /friends/1/edit
    def edit
    end
  
    def create
      @friend = Friend.create(user_id: current_user.id, friend_id: params[:user_id])
      redirect_to root_path
    end
  
    # POST /friends or /friends.json
    def follow
      @followed = User.find(params[:id])
      @friend = Friend.new(user_id: current_user.id, friend_id: @followed.id)
      @friend.save
      redirect_to root_path
  end
  
  def unfollow
      @friend = Friend.find_by(friend_id: params[:id], user_id: current_user)
      @friend.destroy 
      redirect_to root_path
  end
  
  # PATCH/PUT /friends/1 or /friends/1.json
    def update
      respond_to do |format|
        if @friend.update(friend_params)
          format.html { redirect_to @friend, notice: "Friend was successfully updated." }
          format.json { render :show, status: :ok, location: @friend }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @friend.errors, status: :unprocessable_entity }
        end
      end
    end
  
  
   
  
    private
  
      # Use callbacks to share common setup or constraints between actions.
  
     
      def set_friend
        @friend = Friend.find_by(user_id: current_user.id, friend_id: params[:friend_id])
      end
  
    
  
      # Only allow a list of trusted parameters through.
      def friend_params
        params.require(:friend).permit(:friend_id, :user_id)
      end
  end