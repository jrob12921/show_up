class UserEventsController < ApplicationController
  before_action :set_user, only: [:index, :create, :destroy]

  before_action :set_event, only: [:create, :destroy]

  def index
    @user_events = UserEvent.where(id: @user.id)
    # don't know if i will actually use this
  end

  def show
    # Don't think I will need
  end

  def new
    # Don't think I will need
  end

  def create
    @user_event = UserEvent.new(event_id: @event.event_id, user_id: @user.id)

    @user_event.save

    if @user_event.save
      # flash[:message] = "You are now attending this event!"
      
      respond_to do |format|
        format.js
      end    
      
    else
      flash[:message] = "There was a problem..."
      redirect_to event_path(@event.id)
    end
  end

  def edit
    # Don't think I will need
  end

  def update
    # Don't think I will need
  end

  def destroy
    @user_event = Event.find_by(jb_event_id: @event.jb_event_id, user_id: @user.id)

    @user_event.destroy

    if @user_event.destroy
      # flash[:message] = "You are no longer attending this event!"
      
      respond_to do |format|
        format.js
      end    
      
    else
      flash[:message] = "There was a problem..."
      redirect_to event_path(@event.id)
    end
  end

  private

  def event_params
    parms.require(:event).permit(:user_id, :event_id)
  end

  def set_user
    @user = User.find(current_user.id)
  end

  def set_event
    @event = Event.find(params[:id])
  end

end
