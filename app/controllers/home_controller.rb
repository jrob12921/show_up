class HomeController < ApplicationController

  require "search"

  def index

    @user = User.find(current_user.id) if user_signed_in? 

    # Artist Search variables
    @artist_name = params[:q_artist_name]
    @artist_results = ::Search.new.search_artist_by_name(@artist_name)

    # Venue Search variables
    @venue_name = params[:q_venue_name]
    @venue_zipCode = params[:q_venue_zipCode]

    @venue_name.present? ? @venue_results = ::Search.new.search_venue_by_name(@venue_name) : @venue_results = ::Search.new.search_venue_by_zipCode(@venue_zipCode)

    # Event Search variables
    @event_zipCode = params[:q_event_zipCode]
    @event_radius = params[:q_event_radius]
    @event_startDate = params[:q_event_startDate]
    @event_endDate = params[:q_event_endDate]

    @event_results = ::Search.new.search_event_by_location_and_date(@event_zipCode, @event_radius, @event_startDate, @event_endDate)




  end

end
