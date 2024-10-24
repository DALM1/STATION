class ChatRoomsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_chat_room, only: [:show, :join]

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
  end

  def new
    @chat_room = ChatRoom.new
  end

  def create
    @chat_room = ChatRoom.new(chat_room_params)

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

  private

  def set_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  def chat_room_params
    params.require(:chat_room).permit(:name, :description, :password, :image)
  end

  def accessible_chat_rooms
    if session[:chat_room_ids].present?
      ChatRoom.where('password IS NULL OR id IN (?)', session[:chat_room_ids])
    else
      ChatRoom.where(password: nil)
    end
  end
end
