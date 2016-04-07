class HomeController < ApplicationController

  require "search"

  def index

    @user = User.find(current_user.id) if user_signed_in? 
    
    # Artist Search by name
    @artist = params[:q_artist_name]

    @artist_name_results = ::Search.new.search_artist_by_name(@artist)



    # # Venue Search
    # @venue = params[:q_venue]

    # @venue_search = HTTParty.get("http://api.jambase.com/venues?name=#{@venue}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    # @venue_names = []

    # if @venue.present?
    #   for i in 0...@venue_search['Venues'].length
    #     @venue_names << @venue_search['Venues'][i]['Name']
    #   end
    # end

    # # Event Search
    # @event = params[:q_event]

    # @event_search = HTTParty.get("http://api.jambase.com/artists?name=#{@event}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    # @event_names = []

    # if @event.present?
    #   for i in 0...@event_search['Events'].length
    #     @event_names << @event_search['Events'][i]['Name']
    #   end
    # end





  end

end
