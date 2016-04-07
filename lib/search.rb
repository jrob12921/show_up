class Search

  def search_artist_by_name(artist_name)

    artist_search = HTTParty.get("http://api.jambase.com/artists?name=#{artist_name}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    artist_names = []

    if artist_name.present?
      for i in 0...artist_search['Artists'].length
        artist_names << artist_search['Artists'][i]['Name']
      end
    end

    artist_names
  end

  def search_venue_by_name(venue_name)

    venue_search = HTTParty.get("http://api.jambase.com/venues?name=#{venue_name}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    venue_names = []

    if venue_name.present?
      for i in 0...venue_search['Venues'].length
        venue_names << venue_search['Venues'][i]['Name']
      end
    end

    venue_names
  end

  def search_venue_by_zipCode(venue_zipCode)

    venue_search = HTTParty.get("http://api.jambase.com/venues?zipCode=#{venue_zipCode}&page=0&api_key=#{ENV['JAMBASE_API_KEY']}&o=json", verify: false).parsed_response

    venue_names = []

    if venue_name.present?
      for i in 0...venue_search['Venues'].length
        venue_names << venue_search['Venues'][i]['Name']
      end
    end

    venue_names
  end







end

