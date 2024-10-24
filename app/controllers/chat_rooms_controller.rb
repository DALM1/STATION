class ChatRoomsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_chat_room, only: [:show, :join, :destroy]
  before_action :authorize_creator, only: [:destroy]

  def index
    @chat_rooms = if params[:search].present?
                    ChatRoom.where("name LIKE ?", "%#{params[:search]}%")
                  else
                    ChatRoom.all
                  end
  end

  def show
    @post = Post.new
    @chat_rooms = accessible_chat_rooms

    respond_to do |format|
      format.html # Pour la navigation classique
      format.js   # Pour les requêtes AJAX
    end
  end

  def new
    @chat_room = ChatRoom.new
  end

  def create
    @chat_room = ChatRoom.new(chat_room_params)
    @chat_room.creator = current_user

    if @chat_room.save
      redirect_to chat_room_path(@chat_room), notice: "Le salon de discussion a été créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def join
    @post = Post.new
    @chat_rooms = accessible_chat_rooms

    if @chat_room.password.present?
      if session[:chat_room_ids]&.include?(@chat_room.id) || params[:password] == @chat_room.password
        session[:chat_room_ids] ||= []
        session[:chat_room_ids] << @chat_room.id unless session[:chat_room_ids].include?(@chat_room.id)
        redirect_to chat_room_path(@chat_room), notice: "Vous avez rejoint la salle."
      else
        flash[:alert] = "Mot de passe incorrect."
        render :show, status: :unauthorized
      end
    else
      redirect_to chat_room_path(@chat_room), notice: "Vous avez rejoint la salle."
    end
  end

  def destroy
    if @chat_room.destroy
      respond_to do |format|
        format.html { redirect_to chat_rooms_path, notice: "La salle a été supprimée avec succès." }
        format.js   # Pour les requêtes AJAX
      end
    else
      redirect_to chat_room_path(@chat_room), alert: "Impossible de supprimer la salle."
    end
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  def chat_room_params
    params.require(:chat_room).permit(:name, :description, :password, :image)
  end

  def authorize_creator
    unless @chat_room.creator == current_user
      redirect_to chat_rooms_path, alert: "Vous n'avez pas l'autorisation de supprimer cette salle."
    end
  end

  def accessible_chat_rooms
    if session[:chat_room_ids].present?
      ChatRoom.where('password IS NULL OR id IN (?)', session[:chat_room_ids])
    else
      ChatRoom.where(password: nil)
    end
  end
end
