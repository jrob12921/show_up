class DirectMessagesController < ApplicationController

  before_action :set_user
  # Custon route to show only DMs based on specific user IDs
  def user_history

  end

  def event_dm
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


    @other_user = User.find(params[:recipient_id])
    @sent_messages = DirectMessage.where(event_id: @event.id, sender_id: @user.id, recipient_id: @other_user.id)
    @received_messages = DirectMessage.where(event_id: @event.id, sender_id: @other_user.id, recipient_id: @user.id)
    @aggregate_messages = []
    
    @sent_messages.each do |s|
      @aggregate_messages << s
    end

    @received_messages.each do |r|
      @aggregate_messages << r
    end
    # @aggregate_messages.sort!
    # How do you sort by date created field?

    @direct_message = DirectMessage.new
  end

  # To show all my chats
  def my_chats
    # @chat_partners = []
    # @sent = DirectMessage.where(sender_id: @user.id)
    # @received = DirectMessage.where(recipient_id: @user.id)

    # @sent.each do |m|
    #   @chat_partners << User.find(m.recipient_id)
    # end

    # @received.each do |m|
    #   @chat_partners << User.find(m.sender_id)
    # end

    # @chat_partners.uniq!

    # @events = []
    # @chat_partners.each do |p|

    @items = []

    @user_events = UserEvent.where(user_id: @user.id)
    @user_events.each do |e|
      @items << {event_id: e.event_id, jb_event_id: Event.find(e.event_id).jb_event_id}
    end

    @items.each do |i|
      @event_info = ::Search.new.get_event_by_id(i[:jb_event_id])

      i[:event_date] = @event_info[:event_date]
      i[:event_venue] = @event_info[:event_venue]
      
      @event_artists = @event_info[:event_artists]
      @artist_names = []
      # @artist_ids = []
      if @event_artists.present?
        @event_artists.each do |a|
          @artist_names << a['Name']
          # @artist_ids << a['Id']
        end
      end
      i[:artist_names] = @artist_names
    end

    @items.each do |i|
      @sent = DirectMessage.where(event_id: i[:event_id],sender_id: @user.id)
      @received = DirectMessage.where(event_id: i[:event_id], recipient_id: @user.id)
      @partners = []

      @sent.each do |s|
        @partners << s.recipient_id
      end

      @received.each do |r|
        @partners << r.sender_id
      end

      i[:chat_partners] = @partners.uniq
    end



  end

  # used for a single event
  def index
    
  end

  # Not sure if I will use this
  def show
  end

  def new
    @direct_message = DirectMessage.new
  end

  def create
    @direct_message = DirectMessage.new(direct_message_params)
    @direct_message.save

    if @direct_message.save
      
      respond_to do |format|
        format.js
      end    
      
    else
      flash[:message] = "There was a problem..."
      redirect_to :back
    end
  end

  def edit
    @direct_message = DirectMessage.find(params[:id])
  end

  def update
    @direct_message = DirectMessage.find(params[:id])
  end

  def destroy
    @direct_message = DirectMessage.find(params[:id])
  end

  private

  def direct_message_params
    params.require(:direct_message).permit(:sender_id, :recipient_id, :body, :event_id)
  end

  def set_user
    @user = User.find(current_user.id)
  end

end
