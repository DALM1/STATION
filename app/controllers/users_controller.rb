class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  # Affiche le profil de l'utilisateur
  def show
  end

  # Affiche le formulaire d'édition du profil
  def edit
    unless current_user == @user
      redirect_to profile_user_path(current_user), alert: 'Vous ne pouvez modifier que votre propre profil.'
    end
  end

  # Met à jour le profil de l'utilisateur
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

  # Définit l'utilisateur en fonction des paramètres
  def set_user
    @user = User.find(params[:id])
  end

  # Met à jour les informations du profil utilisateur
  def update_user_profile
    if params[:user][:password].present?
      # Si le mot de passe est présent, il est mis à jour avec vérification
      if @user.update_with_password(user_params)
        bypass_sign_in(@user) # Réauthentifie l'utilisateur pour éviter de le déconnecter
        true
      else
        false
      end
    else
      # Met à jour sans changer le mot de passe si non renseigné
      @user.update(user_params.except(:current_password, :password, :password_confirmation))
    end
  end

  # Paramètres autorisés pour la mise à jour du profil utilisateur
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :current_password, :avatar, :background)
  end
end
