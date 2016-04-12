class DirectMessagesController < ApplicationController

  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def direct_message_params
    params.require(:direct_message).permit(:sender_id, :recipient_id, :body)
  end

end
