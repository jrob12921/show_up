class DirectMessagesController < ApplicationController

  # Custon route to show only DMs based on specific user IDs
  def single_dm
  end

  # To show all my chats
  def index
    @my_chat_partners = DirectMessage.where(sender_id: current_user.id).pluck(:recipient_id).uniq

  end

  # Not sure if I will use this
  def show
  end

  def new
    @direct_message = DirectMessage.new
  end

  def create
    @direct_message = DirectMessage.new(direct_message_params)
    @direct_message.save

    # Set up error handling
  end

  def edit
    @direct_message = DirectMessage.find(params[:id])
  end

  def update
    @direct_message = DirectMessage.find(params[:id])
  end

  def destroy
    @direct_message = DirectMessage.find(params[:id])
  end

  private

  def direct_message_params
    params.require(:direct_message).permit(:sender_id, :recipient_id, :body)
  end

end
