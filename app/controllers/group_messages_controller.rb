class GroupMessagesController < ApplicationController
  
  def index
    # Don't know if I will need
  end

  def show
    @event_id = params[:id]
    # @group_messages = GroupMessage.where(user_id: )
  end

  def new
    # Not needed?
  end

  def create
    @group_message = GroupMessage.new(group_message_params)
    @group_message.save

    if @group_message.save
      flash[:message] = "Message Posted Successfully"
      
      respond_to do |format|
        format.js
      end    
      
    else
      flash[:message] = "There was a problem..."
      redirect_to event_path(@group_message.event_id)
    end
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
