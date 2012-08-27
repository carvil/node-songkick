Utils = require './utils'

class Artist

  constructor: (@api_key) ->
    @search = @_search
    @calendar = @_calendar
    @gigography = @_gigography

  ###*
   * Search for a given artist, as described here: http://www.songkick.com/developer/artist-search
   *
   * @param {search_term} - a string representing the search term
   * @param {options}     - an object of options:
   *                       - query: teh query string, usually built using the search_term param
   *                       - apikey: the api key
   *                       - per_page: number of entries per page
   *                       - page: the page number
   * @param {callback}    - a callback function, which will be called with the response json
   *
   * Example:
   *
   * Artist.search("placebo", {page: 2}, my_callback)
   *
   * my_callback will be called with the json response from the request.
  ###
  _search: (search_term, options, callback) ->
    url = "/search/artists.json"
    params =
      query: escape(search_term)
      apikey: @api_key
      per_page: 50
      page: 1
    Utils.get(url, Utils.merge(params,options), callback)

  ###*
   * Search for an artist's calendar, as described here: http://www.songkick.com/developer/upcoming-events-for-artist
   *
   * @param {type}     - a string describing the type of the search id:
   *                    - artist_id: search by artist id
   *                    - music_brainz_id: search by music brainz id
   * @param {id}       - the id of the artist of music brainz
   * @param {options}  - an object of options:
   *                    - apikey: the api key
   *                    - per_page: number of entries per page
   *                    - page: the page number
   * @param {callback} - a callback function, which will be called with the response json
   *
   * Example:
   *
   * Artist.calendar("artist_id", 324967, {page_size: 10}, my_callback)
   *
   * my_callback will be called with the json response from the request.
  ###
  _calendar: (type, id, options, callback) ->
    switch type
      when "artist_id"       then url = "/artists/#{id}/calendar.json"
      when "music_brainz_id" then url = "/artists/mbid:#{id}/calendar.json"
      else
        callback(error: "Unknown type: must be artist_id or music_brainz_id")
        return undefined
    params =
      apikey: @api_key
      per_page: 50
      page: 1
    Utils.get(url, Utils.merge(params,options), callback)


  ###*
   * Search for an artist's past events, as described here: http://www.songkick.com/developer/past-events-for-artist
   *
   * @param type     - a string describing the type of the search id:
   *                    - artist_id: search by artist id
   *                    - music_brainz_id: search by music brainz id
   * @param id       - the id of the artist of music brainz
   * @param options  - an object of options:
   *                    - apikey: the api key
   *                    - per_page: number of entries per page
   *                    - page: the page number
   * @param callback    - a callback function, which will be called with the response json
   *
   * Example:
   *
   * Artist.gigography("artist_id", 324967, {}, my_callback)
   *
   * my_callback will be called with the json response from the request.
  ###
  _gigography: (type, id, options, callback) ->
    switch type
        when "artist_id"       then url = "/artists/#{id}/gigography.json"
        when "music_brainz_id" then url = "/artists/mbid:#{id}/gigography.json"
        else
          callback(error: "Unknown type: must be either artist_id or music_brainz_id")
          return undefined
      params =
        apikey: @api_key
        per_page: 50
        page: 1
      Utils.get(url, Utils.merge(params,options), callback)

module.exports = Artist
