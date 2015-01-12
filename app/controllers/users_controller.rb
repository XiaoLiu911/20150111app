class UsersController < ApplicationController
  before_filter :signed_in_user, 
  only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user, only: [:edit, :update]

def following
@title = "Following"
@user = User.find(params[:id])
@users = @user.followed_users.paginate(page: params[:page], limit: 5)
render 'show_follow'
end

def followers
@title = "Followers"
@user = User.find(params[:id])
@users = @user.followers.paginate(page: params[:page], limit: 5)
render 'show_follow'
end

def new
    @user = User.new
end

def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
end

def index
    @users = User.paginate(page: params[:page], limit: 5)
end

def show
    @user = User.find_by_id(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], limit: 6)
end

def edit
  @user = User.find(params[:id])
end

def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
       render 'edit'
    end
end

def create
    @user = User.new(user_params)
    
    if @user.save
       sign_in @user
       flash[:success] = "Welcome to the Sample App!"
       redirect_to @user
    # Handle a successful save.
    else
       render 'new'
end
end

    private 
        

        def user_params
          params[:user]
           #params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end

        def correct_user
            @user = User.find(params[:id])
            redirect_to(root_path) unless current_user?(@user)
       end
end
