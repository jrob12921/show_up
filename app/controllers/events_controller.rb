class EventsController < ApplicationController
  before_action :set_user, only: [:show]

  require "search"

  # before_action :set_event, only: [:attend, :unattend]

  def index
    # Should be list of all events which at least one person is going to...
    @events = Event.pluck(:jb_event_id).uniq
  end

  def show
    # @event_info = Rails.cache.fetch(:event_info, expires_in: 24.hours) do
    #   ::Search.new.get_event_by_id(params[:id])
    # end
    
    @event = Event.find_or_create_by(jb_event_id: params[:id])
    
    @event_info = ::Search.new.get_event_by_id(params[:id])

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

    @marquee = "#{@artist_names.join(", ")} @ #{@event_venue['Name']} on #{DateTime.parse(@event_date).strftime("%-m/%-d/%y")}"
 
     @user_event = UserEvent.find_or_create_by(user_id: @user.id, event_id: @event.id) 

     @user_event.attending == true ? @user_going = true : @user_going = false

     @url = "https://www.google.com/maps/dir/Current+Location/#{@event_venue['Address']} #{@event_venue['City']} #{@event_venue['StateCode']} #{@event_venue['ZipCode']}"

     @url.gsub!(' ', '+').gsub!('++','+')

    # Ask orlando about this. 
    # There might be a way to use "build" so that the link can exist without creating the record
  end

  def event_users
    @page_header = "Who's Going"
    @event = Event.find(params[:id])
    @users = @event.users
    
    @event_users = []
    @users.each do |u|
      @event_users << u if UserEvent.find_by(event_id: @event.id, user_id: u.id, attending: true).present?
    end

    @jb_event_id = @event.jb_event_id 

    @event_info = ::Search.new.get_event_by_id(@jb_event_id)


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

  private

  def event_params
    parms.require(:event).permit(:jb_event_id)
  end

  def set_user
    @user = User.find(current_user.id)
  end

  # def set_event
  #   @event = Event.find(params[:id])
  # end

end
