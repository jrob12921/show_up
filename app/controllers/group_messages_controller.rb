class GroupMessagesController < ApplicationController
  def show
  end

  private

  def group_message_params
    params.require(:group_message).permit(:event_id, :user_id, :body)
  end

end
