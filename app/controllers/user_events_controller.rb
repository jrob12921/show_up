class UserEventsController < ApplicationController
  before_action :set_user, only: [:index, :show, :create, :destroy]

  before_action :set_event, only: [:show, :create, :destroy]

  require "search"

  def my_events
    @user_events = UserEvent.where(user_id: @user_id)
  end

  # my_events page
  def index
    @user_events = UserEvent.where(user_id: @user.id)
    # don't know if i will actually use this
    @jb_event_ids = []
    @user_events.each do |ue|
      @jb_event_ids << Event.find(ue.event_id).jb_event_id
    end

    @jb_events = []
    @jb_event_ids.each do |j|
      @jb_events << ::Search.new.get_event_by_id(j)
    end


  end

  def show
    @user_event = UserEvent.find_or_create_by(event_id: @event.id, user_id: @user.id)

    @all_users = UserEvent.where(event_id: @event.id)

    @event_info = ::Search.new.get_event_by_id(@event.jb_event_id)

    @jb_event_id = @event_info[:jb_event_id]

    @event_date = @event_info[:event_date]
    @event_venue = @event_info[:event_venue]
    @event_artists = @event_info[:event_artists]
    @event_url = @event_info[:event_url]

    @artist_names = []
    # @artist_ids = []
    @event_artists.each do |a|
      @artist_names << a['Name']
      # @artist_ids << a['Id']
    end

    @marquee = "<strong>#{@artist_names.join(", ")}</strong><br><strong>#{@event_venue['Name']}</strong><br><strong>#{DateTime.parse(@event_date).strftime("%-m/%-d/%y")}</strong>"

    @group_message = GroupMessage.where(event_id: @event.id, user_id: @user.id)

    # @user_going = UserEvent.find_by(user_id: @user.id, event_id: @event.id).present? ? true : false

  end

  def new
    # Don't think I will need
  end

  def create
    @user_event = UserEvent.new(event_id: @event.id, user_id: @user.id)

    @user_event.save

    if @user_event.save
      # flash[:message] = "You are now attending this event!"
      
      # respond_to do |format|
      #   format.js
      # end    

      redirect_to event_path(@event.id)

      
    else
      flash[:message] = "There was a problem..."
      redirect_to event_path(@event.id)
    end
  end

  def destroy
    @user_event = UserEvent.find(params[:id])

    @user_event.destroy

    redirect_to root_path
  end

  private

  def event_params
    parms.require(:event).permit(:user_id, :event_id)
  end

  def set_user
    @user = User.find(current_user.id)
  end

  def set_event
    @event = UserEvent.find(params[:id]).event
  end

end
