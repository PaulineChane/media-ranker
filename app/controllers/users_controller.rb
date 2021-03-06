class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      head :not_found
      return
    else
      @works = @user.works
    end
  end

  def login_form
    @user = User.new
  end

  def login
    username = params[:user][:username]
    @user = User.find_by(username: username)

    if @user
      session[:user_id] = @user.id
      flash[:success] = "Successfully logged in as existing user #{username}"
    else
      @user = User.create(username: username)

      if @user.valid?
        session[:user_id] = @user.id
        flash[:success] = "Successfully created new user #{username} with ID #{@user.id}"
      else
        flash.now[:error] = "A problem occurred: Could not log in"
        render :login_form, status: :bad_request
        return
      end
    end

    redirect_to root_path
    return
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"
    redirect_to root_path
    return
  end
end
