class ThreadMsgsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @thread_msg = @post.threads.build(thread_msg_params)
    @thread_msg.user = current_user
    if @thread_msg.save
      redirect_to chat_room_path(@post.chat_room)
    else
      render 'chat_rooms/show'
    end
  end

  private

  def thread_msg_params
    params.require(:thread_msg).permit(:content)
  end
end
