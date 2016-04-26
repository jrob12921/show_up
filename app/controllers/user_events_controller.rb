class UserEventsController < ApplicationController
  before_action :set_user, only: [:index, :show, :create, :destroy]

  before_action :set_event, only: [:show, :create, :destroy]

  require "search"

  def my_events
    @user_events = UserEvent.where(user_id: @user_id)
  end

  # my_events page
  def index
    @page_header = "My Events"
    @user_events = UserEvent.where(user_id: @user.id, attending: true )
    # don't know if i will actually use this
    @jb_event_ids = []
    @user_events.each do |ue|
      @jb_event_ids << Event.find(ue.event_id).jb_event_id
    end

    @jb_events = []
    @jb_event_ids.each do |j|
      @jb_events << ::Search.new.get_event_by_id(j)
    end

    # @artist_names = []
    # @jb_events.each do |a|
    #   artists = []
    #   a[:event_artists].each do |n|
    #     artists << n['Name']
    #   end
    #   @artist_names << artists
    # end

  end

  def show
    @page_header = "You're Seeing:"
    @user_event = UserEvent.find_by(event_id: @event.id, user_id: @user.id)

    # @user_event.update(attending: true)

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

    @user_event.attending == true ? @user_going = true : @user_going = false

    @url = "https://www.google.com/maps/place/#{@event_venue['Address']}, #{@event_venue['City']}, #{@event_venue['StateCode']} #{@event_venue['ZipCode']}".gsub!(' ', '+').gsub!('++','+')

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

  def attend
    @user_event = UserEvent.find(params[:id])
    @user_event.update(attending: true)
    redirect_to user_event_path(@user_event.id)

  end

  def unattend
    @user_event = UserEvent.find(params[:id])
    @user_event.update(attending: false)
    redirect_to event_path(@user_event.event.jb_event_id)
  end

  private

  def event_params
    parms.require(:event).permit(:user_id, :event_id, :attending)
  end

  def set_user
    @user = User.find(current_user.id)
  end

  def set_event
    @event = UserEvent.find(params[:id]).event
  end

end
