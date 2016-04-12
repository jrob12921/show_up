class Search

   def get_artist_id(artist_name)
    artist_search = HTTParty.get("http://api.jambase.com/artists?name=#{artist_name.gsub!(' ', '+')}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    artist_search['Artists'][0]['Id']
  end

  def get_venue_id(venue_name)
    venue_search = HTTParty.get("http://api.jambase.com/venues?name=#{venue_name.gsub!(' ', '+')}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    venue_search['Venues'][0]['Id']
  end
  # below used for artists/venues
  def search_by_name(name)
    # put name into artist search
    artist_search = HTTParty.get("http://api.jambase.com/artists?name=#{name.gsub!(' ', '+')}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    artist_names = []
    for i in 0...artist_search['Artists'].length
      artist = artist_search['Artists'][i]
      artist_names << {jb_artist_id: artist['Id'], artist_name: artist['Name']}
    end

    # Put name into venue search
    venue_search = HTTParty.get("http://api.jambase.com/venues?name=#{name.gsub!(' ', '+')}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    venue_names = []
    for i in 0...venue_search['Venues'].length
      venue = venue_search['Venues'][i]
      venue_names << {jb_venue_id: venue['Id'], venue_name: venue['Name']}
    end

    [artist_names, venue_names]
  end
  # below used for venues/events
  def search_by_zip(zip_code)
    #put zip into venue search
    venue_search = HTTParty.get("http://api.jambase.com/venues?zipCode=#{zip_code}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    venue_names = []

    for i in 0...venue_search['Venues'].length
      venue = venue_search['Venues'][i]
      venue_names << {jb_venue_id: venue['Id'], venue_name: venue['Name']}
    end

    #put zip into event search
    event_search = HTTParty.get("http://api.jambase.com/events?zipCode=#{zip_code}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    events = []
    # Below, venue is a hash, artists is an array of hashes
    for i in 0...event_search['Events'].length
      event = event_search['Events'][i]
      events << {jb_event_id: event['Id'], event_date: event['Date'], event_venue: event['Venue'], event_artists: event['Artists'], event_url: event['TicketUrl']}
    end

    [venue_names, events]
  end

  # private

  # inputs = {jb_artist_id: a, jb_venue_id: b, jb_event_id: c, zip_code: d, radius: e, start_date: f, end_date: g, artist_name: h, venue_name: i}
  def insert_into_url!(type, inputs={})  
    if type == "event"
      @url = "http://api.jambase.com/events?"

      if inputs['jb_event_id'].present? || inputs['jb_artist_id'].present?
        # In an event search, only event_id and artist_id can use zip_code and radius, not venue_id
        @url += "id=#{inputs['jb_event_id']}&" if inputs['jb_event_id'].present?
        @url += "artistId=#{inputs['jb_artist_id']}&" if inputs['jb_artist_id'].present?  
        @url += "zipCode=#{zip_code}&" if inputs['zip_code'].present?
        @url += "radius=#{radius}&" if inputs['radius'].present?
      
      elsif inputs['jb_venue_id'].present?
        @url += "venueId=#{inputs['jb_venue_id']}&"
      end

      # start_date and end_date can be used in all scenarios 
      # format is yyyy-mm-dd
      if inputs['start_date'].present?
        @url += "startDate=#{start_date}&" 
      # use end_date as the startDate if a user inputs end date instead of start date
      elsif !inputs['start_date'].present? && inputs['end_date'].present?
        @url += "startDate=#{end_date}"
      # end_date can only be used if start date is also used
      elsif inputs['end_date'].present? && inputs['start_date'].present?
        @url += "endDate=#{end_date}&"
      end

    elsif type == "artist"
      @url = "http://api.jambase.com/artist?"

      if inputs['jb_artist_id'].present?
        @url += "id=#{inputs['jb_artist_id']}&"

      elsif inputs['artist_name'].present?
        @url += "name=#{inputs['artist_name'].gsub!(' ', '+')}&"
      end

    elsif type == "venue"
      @url = "http://api.jambase.com/venues?"

      if inputs['jb_venue_id'].present?
        @url += "id=#{inputs['jb_venue_id']}&"  
      elsif inputs['venue_name'].present?
        @url += "name=#{inputs['venue_name'].gsub!(' ', '+')}&"
      elsif inputs['zip_code'].present?
        @url += "zipCode=#{zip_code}&"
      end
    # exit massive if statement here
    end

    # Randomly Generate API KEY from list of active keys
    # This should be removed once API Key has more calls and 
    api_keys = [
        ENV['JAMBASE_API_KEY']
        # ,ENV['JAMBASE_2'],
        # ,ENV['JAMBASE_3'],
        # ,ENV['JAMBASE_4'],
        # ,ENV['JAMBASE_5']
      ]

    @url += "page=0&api_key=#{api_keys.sample}&o=json" # "page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json"

    response = HTTParty.get(@url, verify: false).parsed_response

    # Is this notation valid
    # response.make_api_call_pretty!(type)
    # what about this
    make_api_call_pretty!(response,type)
  end

  private

  def make_api_call_pretty!(api_call, type)
    response = []
    
    if type == "event"
      for i in 0...api_call['Events'].length
        event = api_call['Events'][i]
        # See if I can get venue_ID??
        response << {jb_event_id: event['Id'], event_date: event['Date'], event_venue: event['Venue'], event_artists: event['Artists'], event_url: event['TicketUrl']}
      end

    elsif type == "artist"
      for i in 0...api_call['Artists'].length
        artist = api_call['Artists'][i]
        response << << {artist_id: artist['Id'], artist_name: artist['Name']}
      end

    elsif type =="venue"
      for i in 0...api_call['Venues'].length
        venue = api_call['Venues'][i]
        response << {venue_id: venue['Id'], venue_name: venue['Name']}
      end
    end
        
    response
  end

  def change_page(url) 
  end

end


