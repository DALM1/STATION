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
    @chat_room = ChatRoom.find(params[:id])
    @post = Post.new
    @chat_rooms = ChatRoom.all
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
    if @chat_room.password.present?
      if params[:password] == @chat_room.password
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
end
