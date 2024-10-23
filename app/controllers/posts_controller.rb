class PostsController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @post = @chat_room.posts.build(post_params)
    @post.user = current_user

    if @post.save
      redirect_to chat_room_path(@chat_room), notice: 'Message envoyé.'
    else
      flash[:alert] = 'Le message ne peut pas être vide.'
      redirect_to chat_room_path(@chat_room)
    end
  end

  private

  def post_params
    params.require(:post).permit(:content, :file)
  end
end
