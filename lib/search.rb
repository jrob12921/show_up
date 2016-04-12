class Search

   def get_artist_id(artist_name)
    artist_search = HTTParty.get("http://api.jambase.com/artists?name=#{artist_name.gsub!(' ', '+')}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    artist_search['Artists'][0]['Id']
  end

  def get_venue_id(venue_name)
    venue_search = HTTParty.get("http://api.jambase.com/venues?name=#{venue_name.gsub!(' ', '+')}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    venue_search['Venues'][0]['Id']
  end

  private

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

    # response.make_api_call_pretty(type)!
  end


  def make_api_call_pretty!(api_call, type)
    pretty = []
    
    if type == "event"
      for i in 0...api_call['Events'].length
        event = event_search['Events'][i]
        # See if I can get venue_ID
        pretty << {event_id: event['Id'], event_date: event['Date'], event_venue: event['Venue'], event_artists: event['Artists'], event_url: event['TicketUrl']}
      end

    elsif type == "artist"

    elsif type =="venue"

    end
        
    pretty
  end

  def change_page(url) 
  end

end


