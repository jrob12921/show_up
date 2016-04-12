class SearchController < ApplicationController

  require "search"

  def index
    @user = User.find(current_user.id) if user_signed_in? 

  end

  def results
    if params[:q_name].present?
      @name = params[:q_name]
      @name_results = ::Search.new.search_by_name(@name)
      # @artist_results = @name_results[0]
      @venue_results = @name_results[1]

    elsif params[:q_zip_code].present?
      @zip_code = params[:q_zip_code] 
      @zip_results = ::Search.new.search_by_zip(@zip_code)
      @venue_results = @zip_results[0]
      @event_results = @zip_results[1]

    end
  end


  def artist_events
    @artist_id = params[:id]
    @artist_events = ::Search.new.get_artist_events_by_id(@artist_id)
    # @artist_name = @artist_events['Events']['Artists'][0]['Name']
  end

  def venue_events
    @venue_id = params[:id]
    @venue_events = ::Search.new.get_venue_events_by_id(@venue_id)
    # This may need modification
    # @venue_name = @venue_events['Events'][0]['Venue']['Name']
  end

  def single_event
    @event_id = params[:id]
    @event_info = ::Search.new.get_event_by_id(@event_id)
  end

  def local_events
  end

end