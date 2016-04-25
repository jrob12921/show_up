class SearchController < ApplicationController

  require "search"
  # use 'Rails.cache.clear' to clear cache
  def index
    @user = User.find(current_user.id) if user_signed_in? 

  end

  def results
    if params[:q_name].present?
      @name = params[:q_name]
      # @name_results = Rails.cache.fetch(:name_results, expires_in: 24.hours) do
      #   ::Search.new.search_by_name(@name)
      # end
      @name_results = ::Search.new.search_by_name(@name)

      @artist_results = @name_results[0]
      @venue_results = @name_results[1]

    elsif params[:q_zip_code].present?

      @zip_code = params[:q_zip_code] 
      if !@zip_code.present?
        flash[:message] = "Please type SOMETHING before you hit search."

      elsif valid_zip?(@zip_code)

        # @zip_results = Rails.cache.fetch(:zip_results, expires_in: 24.hours) do
        #  ::Search.new.search_by_zip(@zip_code)
        # end
        @zip_results = ::Search.new.search_by_zip(@zip_code)

        @venue_results = @zip_results[0]
        @event_results = @zip_results[1]

        @artist_names = []
        @event_results.each do |a|
          artists = []
          a[:event_artists].each do |n|
            artists << n['Name']
          end
          @artist_names << artists
        end

      else
        flash[:message] = "Please enter a 5-digit number if you want to search by ZIP Code!"
        redirect_to root_path
      end

    end
  end


  def artist_events
    @artist_id = params[:id]
    # @artist_events = Rails.cache.fetch(:artist_events, expires_in: 24.hours) do
    #   ::Search.new.get_artist_events_by_id(@artist_id)
    # end

    @artist_events = ::Search.new.get_artist_events_by_id(@artist_id)

    # @artist_name = Rails.cache.fetch(:artist_name, expires_in: 24.hours) do
    #   ::Search.new.get_artist_name_by_id(@artist_id)
    # end
    @artist_name = ::Search.new.get_artist_name_by_id(@artist_id)

    @artist_names = []

    @page_header = @artist_name
    if @artist_events.present?
      @artist_events.each do |a|
        artists = []
        a[:event_artists].each do |n|
          artists << n['Name']
        end
        @artist_names << artists
      end

    else
      @message = "No Upcoming Events for this Artist"
    end

  end

  def venue_events
    @venue_id = params[:id]
    # @venue_events = Rails.cache.fetch(:venue_events, expires_in: 24.hours) do
    #   ::Search.new.get_venue_events_by_id(@venue_id)
    # end
    @venue_events = ::Search.new.get_venue_events_by_id(@venue_id)
    @artist_names = []
    
    if @venue_events.present?
      # To avoid another API call
      @venue_name = @venue_events.first[:event_venue]['Name']
      @page_header = @venue_name

      @venue_events.each do |a|
        artists = []
        a[:event_artists].each do |n|
          artists << n['Name']
        end
        @artist_names << artists
      end

    else
      @message = "No Upcoming Events at this Venue!"
      # @page_header = Rails.cache.fetch(:page_header, expires_in: 24.hours) do
      #   ::Search.new.get_venue_name_by_id(@venue_id)
      # end
      @page_header = ::Search.new.get_venue_name_by_id(@venue_id)
    end


  end

  def local_events
  end

  private

  def valid_zip?(zip)
    zip.length == 5
  end

end