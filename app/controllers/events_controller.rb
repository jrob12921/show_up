class EventsController < ApplicationController

  def index
    # Should be list of all events which at least one person is going too...
    @events = Event.uniq.pluck(:jb_event_id)
  end

  def show
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


    @marquee = "See #{@artist_names.join(", ")} @ #{@event_venue['Name']}"

    @user = User.find(current_user.id)
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
