class Search

  def search_artist_by_name(artist_name)

    artist_name.gsub!(' ', '+')

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

    venue_name.gsub!(' ', '+')

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

    url += "endDate=#{endDate}&" if endDate.present?

    url += "page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json"

    event_search = HTTParty.get(url, verify: false).parsed_response

    events = []

    if zipCode.present? || startDate.present?
      for i in 0...event_search['Events'].length
        event = event_search['Events'][i]
        # See if I can get venue_ID
        events << {event_id: event['Id'], event_date: event['Date'], event_venue: event['Venue'], event_artists: event['Artists'], event_url: event['TicketUrl']}
      end
    end

    events
  end

  def get_event_by_id(event_id)
    HTTParty.get("http://api.jambase.com/events?id=#{event_id}&api_key=#{ENV['JAMBASE_API_KEY']}", verify: false).parsed_response
    # Maybe create my own has to return?
  end

  def get_artist_events(artist_name, zipCode, radius, startDate, endDate)
    artist_id = ::Search.new.get_artist_id(artist_name)

    url = "http://api.jambase.com/events?"

    url += "artistId=#{artist_id}&"

    url += "zipCode=#{zipCode}&" if zipCode.present?

    url += "radius=#{radius}&" if radius.present?
    # yyyy-mm-dd
    url += "startDate=#{startDate}&" if startDate.present?

    url += "endDate=#{endDate}&" if endDate.present?

    url += "page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json"

    artist_events = HTTParty.get(url, verify: false).parsed_response

    events = []

    for i in 0...artist_events['Events'].length
      event = artist_events['Events'][i]
      # See if I can get venue ID...
      events << {event_id: event['Id'], event_date: event['Date'], event_venue: event['Venue'], event_artists: event['Artists'], event_url: event['TicketUrl']}
    end

    events
  end

  def get_venue_events(venue_name, startDate, endDate)
    venue_id = ::Search.new.get_venue_id(venue_name)
    
    url = "http://api.jambase.com/events?"

    url += "artistId=#{venue_id}&"
    # yyyy-mm-dd
    url += "startDate=#{startDate}&" if startDate.present?

    url += "endDate=#{endDate}&" if endDate.present?

    url += "page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json"

    venue_events = HTTParty.get(url, verify: false).parsed_response

    events = []

    for i in 0...venue_events['Events'].length
      event = venue_events['Events'][i]
      events << {event_id: event['Id'], event_date: event['Date'], event_venue: event['Venue'], event_artists: event['Artists'], event_url: event['TicketUrl']}
    end

    events
  end

  def get_artist_id(artist_name)
    artist_name.gsub!(' ', '+')

    artist_search = HTTParty.get("http://api.jambase.com/artists?name=#{artist_name}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    artist_search['Artists'][0]['Id']
    
  end

  def get_venue_id(venue_name)
    venue_name.gsub!(' ', '+')

    venue_search = HTTParty.get("http://api.jambase.com/venues?name=#{venue_name}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    venue_search['Venues'][0]['Id']
  end

  private

  def self.api_randomizer
    api_keys = [
        ENV['JAMBASE_API_KEY'],
        ENV['JAMBASE_2'],
        ENV['JAMBASE_3'],
        ENV['JAMBASE_4'],
        ENV['JAMBASE_5']
      ]
    api_keys.sample
  end


end

