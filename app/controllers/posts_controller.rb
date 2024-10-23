class PostsController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @post = @chat_room.posts.build(post_params)
    @post.user = current_user

    if @post.save
      redirect_to @chat_room
    else
      flash[:alert] = "Le message n'a pas pu être envoyé."
      redirect_to @chat_room
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
