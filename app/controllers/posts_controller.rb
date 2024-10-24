class PostsController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @post = @chat_room.posts.build(post_params)
    @post.user = current_user

    if contains_link?(@post.content)
      preview_data = generate_link_preview(@post.content)
      @post.preview_data = preview_data if preview_data.present?
    end

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

  def contains_link?(content)
    content.match?(/https?:\/\/[\S]+/)
  end

  def generate_link_preview(content)
    url = content[/https?:\/\/[\S]+/]
    PreviewGeneratorService.new(url).call if url.present?
  end
end
