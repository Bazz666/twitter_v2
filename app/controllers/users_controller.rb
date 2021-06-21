class UsersController < ApplicationController

 
    def show
        @users = User.all
    end


    private

    # Use callbacks to share common setup or constraints between actions.

    def set_user
      @user = User.find(params[:id])
    end


    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:friend_id, :user_id)
    end
    

end