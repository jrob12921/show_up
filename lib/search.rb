class Search

  #  def get_artist_id(artist_name)
  #   artist_search = HTTParty.get("http://api.jambase.com/artists?name=#{artist_name.gsub!(' ', '+')}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

  #   artist_search['Artists'][0]['Id']
  # end

  # def get_venue_id(venue_name)
  #   venue_search = HTTParty.get("http://api.jambase.com/venues?name=#{venue_name.gsub!(' ', '+')}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

  #   venue_search['Venues'][0]['Id']
  # end

  # below used for artists/venues
  def search_by_name(name)
    # put name into artist search
    artist_search = HTTParty.get("http://api.jambase.com/artists?name=#{name.gsub!(' ', '+')}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    artist_names = []
    if artist_search.present?
      # This next line is giving me an issue
      for i in 0...artist_search['Artists'].length
        artist = artist_search['Artists'][i]
        artist_names << {jb_artist_id: artist['Id'], artist_name: artist['Name']}
      end
    end

    # Put name into venue search
    venue_search = HTTParty.get("http://api.jambase.com/venues?name=#{name.gsub!(' ', '+')}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    venue_names = []
    if venue_search.present?
      for i in 0...venue_search['Venues'].length
        venue = venue_search['Venues'][i]
        venue_names << {jb_venue_id: venue['Id'], venue_name: venue['Name']}
      end
    end

    [artist_names, venue_names]
  end

  # below used for venues/events
  def search_by_zip(zip_code)
    #put zip into venue search
    venue_search = HTTParty.get("http://api.jambase.com/venues?zipCode=#{zip_code}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    venue_names = []

    if venue_search.present?
      for i in 0...venue_search['Venues'].length
        venue = venue_search['Venues'][i]
        venue_names << {jb_venue_id: venue['Id'], venue_name: venue['Name']}
      end
    end

    #put zip into event search
    event_search = HTTParty.get("http://api.jambase.com/events?zipCode=#{zip_code}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    events = []
    # Below, venue is a hash, artists is an array of hashes
    if event_search.present?
      for i in 0...event_search['Events'].length
        event = event_search['Events'][i]
        events << {jb_event_id: event['Id'], event_date: event['Date'], event_venue: event['Venue'], event_artists: event['Artists'], event_url: event['TicketUrl']}
      end
    end

    [venue_names, events]
  end

  
  def get_artist_events_by_id(artist_id)
    artist_events = HTTParty.get("http://api.jambase.com/events?artistId=#{artist_id}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    events = []

    for i in 0...artist_events['Events'].length
      event = artist_events['Events'][i]
      events << {jb_event_id: event['Id'], event_date: event['Date'], event_venue: event['Venue'], event_artists: event['Artists'], event_url: event['TicketUrl']}
    end

    events
  end


  def get_venue_events_by_id(venue_id)
    venue_events = HTTParty.get("http://api.jambase.com/events?artistId=#{venue_id}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    events = []

    for i in 0...venue_events['Events'].length
      event = venue_events['Events'][i]
      events << {jb_event_id: event['Id'], event_date: event['Date'], event_venue: event['Venue'], event_artists: event['Artists'], event_url: event['TicketUrl']}
    end

    events
  end

end


