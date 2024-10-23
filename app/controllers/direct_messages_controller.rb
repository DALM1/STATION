class DirectMessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @direct_messages = DirectMessage.where(receiver: current_user)
  end

  def create
    @direct_message = DirectMessage.new(direct_message_params)
    @direct_message.sender = current_user
    if @direct_message.save
      Notification.create(user: @direct_message.receiver, message: "Vous avez un nouveau message de #{current_user.username}")
      redirect_to direct_messages_path
    else
      render :index
    end
  end

  private

  def direct_message_params
    params.require(:direct_message).permit(:content, :receiver_id)
  end
end
