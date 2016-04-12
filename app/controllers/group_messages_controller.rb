class GroupMessagesController < ApplicationController
  
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

  def group_message_params
    params.require(:group_message).permit(:event_id, :user_id, :body)
  end

end
