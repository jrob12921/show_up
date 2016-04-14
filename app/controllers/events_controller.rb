class EventsController < ApplicationController

  def index
    # Should be list of all events which at least one person is going too...
    @events = Event.pluck(:jb_event_id).uniq
  end

  def show
    @event_info = Rails.cache.fetch(:event_info, expires_in: 24.hours) do
      ::Search.new.get_event_by_id(params[:id])
    end
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


    @marquee = "See: <strong>#{@artist_names.join(", ")}</strong><br>At: <strong>#{@event_venue['Name']}</strong><br>On: <strong>#{DateTime.parse(@event_date).strftime("%-m/%-d/%y")}</strong>"

    @user = User.find(current_user.id)

    @group_messages = GroupMessage.where(event_id: @event.id, user_id: @user.id)
    @new_group_message = GroupMessage.new
  end

  def new
    # Not needed because of find_or_create_by method in show
  end

  def create
    # Not needed because of find_or_create_by method in show
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

  private

  def event_params
    parms.require(:event).permit(:user_id, :jb_event_id)
  end

end
