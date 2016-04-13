class SearchController < ApplicationController

  require "search"
  # user 'Rails.cache.clear' to clear cache
  def index
    @user = User.find(current_user.id) if user_signed_in? 

  end

  def results
    if params[:q_name].present?
      @name = params[:q_name]
      @name_results = Rails.cache.fetch(:name_results, expires_in: 24.hours) do
        ::Search.new.search_by_name(@name)
      end
      # @artist_results = @name_results[0]
      @venue_results = @name_results[1]

    elsif params[:q_zip_code].present?
      @zip_code = params[:q_zip_code] 
      @zip_results = Rails.cache.fetch(:zip_results, expires_in: 24.hours) do
       ::Search.new.search_by_zip(@zip_code)
      end
      @venue_results = @zip_results[0]
      @event_results = @zip_results[1]

    end
  end


  def artist_events
    @artist_id = params[:id]
    @artist_events = Rails.cache.fetch(:artist_events, expires_in: 24.hours) do
      ::Search.new.get_artist_events_by_id(@artist_id)
    end
    # @artist_name = @artist_events['Events']['Artists'][0]['Name']

    @artist_name = Rails.cache.fetch(:artist_name, expires_in: 24.hours) do
      ::Search.new.get_artist_name_by_id(@artist_id)
    end
    if !@artist_events.present?
      @message = "No Upcoming Events for this Artist"
    end

  end

  def venue_events
    @venue_id = params[:id]
    @venue_events = Rails.cache.fetch(:venue_events, expires_in: 24.hours) do
      ::Search.new.get_venue_events_by_id(@venue_id)
    end
    if @venue_events.present?
      # To avoid another API call
      @venue_name = @venue_events.first[:event_venue]['Name']
      @page_header = @venue_name
    else
      @message = "No Upcoming Events at this Venue!"
      @page_header = Rails.cache.fetch(:page_header, expires_in: 24.hours) do
        ::Search.new.get_venue_name_by_id(@venue_id)
      end
    end
  end

  def local_events
  end

end