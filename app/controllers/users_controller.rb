class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  def show
  end

  def edit
    unless current_user == @user
      redirect_to profile_user_path(current_user), alert: 'Vous ne pouvez modifier que votre propre profil.'
    end
  end

  def update
    if current_user == @user
      if update_user_profile
        redirect_to profile_user_path(@user), notice: 'Profil mis à jour avec succès.'
      else
        render :edit
      end
    else
      redirect_to profile_user_path(current_user), alert: 'Vous ne pouvez modifier que votre propre profil.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def update_user_profile
    if params[:user][:password].present?
      if @user.update_with_password(user_params)
        bypass_sign_in(@user)
        true
      else
        false
      end
    else
      @user.update(user_params.except(:current_password, :password, :password_confirmation))
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :current_password, :avatar)
  end
end
