class Search

  def search_artist_by_name(artist_name)

    artist_search = HTTParty.get("http://api.jambase.com/artists?name=#{artist_name}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    artist_names = []

    if artist_name.present?
      for i in 0...artist_search['Artists'].length
        artist = artist_search['Artists'][i]
        artist_names << {artist_id: artist['Id'], artist_name: artist['Name']}
      end
    end

    artist_names
  end

  def search_venue_by_name(venue_name)

    venue_search = HTTParty.get("http://api.jambase.com/venues?name=#{venue_name}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    venue_names = []

    if venue_name.present?
      for i in 0...venue_search['Venues'].length
        venue = venue_search['Venues'][i]
        venue_names << {venue_id: venue['Id'], venue_name: venue['Name']}
      end
    end

    venue_names
  end

  def search_venue_by_zipCode(venue_zipCode)

    venue_search = HTTParty.get("http://api.jambase.com/venues?zipCode=#{venue_zipCode}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    venue_names = []

    if venue_zipCode.present?
      for i in 0...venue_search['Venues'].length
        venue = venue_search['Venues'][i]
        venue_names << {venue_id: venue['Id'], venue_name: venue['Name']}
      end
    end

    venue_names
  end

  def search_event_by_location_and_date(zipCode, radius, startDate, endDate)

    url = "http://api.jambase.com/events?"

    url += "zipCode=#{zipCode}&" if zipCode.present?

    url += "radius=#{radius}&" if radius.present?
    # yyyy-mm-dd
    url += "startDate=#{startDate}&" if startDate.present?

    url+= "endDate=#{endDate}&" if endDate.present?

    url += "page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json"

    event_search = HTTParty.get(url, verify: false).parsed_response

    events = []

    if zipCode.present? || startDate.present?
      for i in 0...event_search['Events'].length
        event = event_search['Events'][i]
        events << {event_id: event['Id'], event_date: event['Date'], event_venue: event['Venue'], event_artists: event['Artists'], event_url: event['TicketUrl']}
      end
    end

    events
  end



end

