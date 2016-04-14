class EventsController < ApplicationController
  before_action :set_user, only: [:show, :attend, :unattend]

  before_action :set_event, only: [:attend, :unattend]

  def index
    # Should be list of all events which at least one person is going too...
    @events = Event.pluck(:jb_event_id).uniq
  end

  def show
    # @event_info = Rails.cache.fetch(:event_info, expires_in: 24.hours) do
    #   ::Search.new.get_event_by_id(params[:id])
    # end
    
    @event_info = ::Search.new.get_event_by_id(params[:id])

    @event_id = @event_info[:jb_event_id]
    @event = Event.find_or_create_by(jb_event_id: @event_id)

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

    @group_messages = GroupMessage.where(event_id: @event.id, user_id: @user.id)
    @new_group_message = GroupMessage.new

  end

  def new
    # Not needed because of find_or_create_by method in show
  end

  def create
    # Not needed
  end

  def edit
    # Not needed
  end

  def update
    # Not needed
  end

  def destroy
    # Not needed
  end

  def attend
    @user_event = Event.new(jb_event_id: @event.jb_event_id, user_id: @user.id)

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

  def unattend
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
    parms.require(:event).permit(:user_id, :jb_event_id)
  end

  def set_user
    @user = User.find(current_user.id)
  end

  def set_event
    @event = Event.find(params[:id])
  end

end
