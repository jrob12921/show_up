class EventsController < ApplicationController

  # before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
    @event = Event.find_or_create_by(jb_event_id: params[:id])

    
    
    @user = User.find(current_user.id)
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

  def event_params
    parms.require(:event).permit(:user_id, :jb_event_id)
  end

  # def set_event
  #   @event_id = params[:id]
  # end

end
