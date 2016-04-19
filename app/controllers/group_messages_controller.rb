class GroupMessagesController < ApplicationController
  
  require "search"

  before_action :set_user, only: [:index]

  def index
    # Don't know if I will need
    @event = Event.find(params[:event_id])
    @event_info = ::Search.new.get_event_by_id(@event.jb_event_id)
    
    # @jb_event_id = @event_info[:jb_event_id]

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

    @user_going = UserEvent.find_by(user_id: @user.id, event_id: @event.id).present? ? true : false
  end

  def show
  end

  def new
    # Not needed?
  end

  def create
    @group_message = GroupMessage.find_or_create_by(group_message_params)
    @group_message.save

    if @group_message.save
      # flash[:message] = "Message Posted Successfully"
      
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

  def set_user
    @user = User.find(current_user.id)
  end

end
