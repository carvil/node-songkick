http = require 'http'
querystring = require 'querystring'

module.exports =

  ###*
   * Transforms an object in a query string
   *
   * @param {query}    - the query object, e.g. {q: "pink floyd", apikey: "abc"}
   * @returns {string} - the input string in query format
   *
   * Example:
   *
   * Utils.stringifyQuery({q: "some string"})
   * > 'q=some%20string'
  ###
  stringifyQuery: (query) ->
    for key, value of query
      query[key] = String(value) if typeof value is 'boolean'
    querystring.stringify(query)

  ###*
   * Merges two objects into one
   *
   * @param {defaults} - an object, e.g. {id: 1}
   * @param {options}  - an object, e.g. {apikey: "abc"}
   * @returns {object} - both input objects merged, e.g. {id: 1, apikey: "abc"}
   *
   * Example:
   *
   * Utils.merge({id: 1}, {q: "some string"})
   * > {id: 1, q: "some string"}
  ###
  merge: (defaults, options) ->
    defaults = defaults or {}
    if options and typeof options is "object"
      keys = Object.keys(options)

      for key in keys
        defaults[key] = options[key]

    defaults

  ###*
   * Performs an http get request
   *
   * @param {uri}      - the uri, e.g. '/search/artists.json'
   * @param {params}   - an object, e.g. {apikey: "abc", q: "some query"}
   * @param {callback} - a function to call after the request
   *
   * Example:
   *
   * Utils.get("/search", {apikey: "abc", q: "some query"}, my_callback)
  ###
  get: (uri, params, callback)->
    query = @stringifyQuery(params)
    uri = uri + "?#{query}" if query
    @execute 'GET', uri, callback

  ###*
   * Performs an http request
   *
   * @param {verb}     - string specifying the http verb, e.g. 'GET'
   * @param {uri}      - string representing the songkick uri to query, e.g. '/search/artists.json'
   * @param {callback} - a function to call after the request
   *
   * Example:
   *
   * Utils.execute("GET", "/search?apikey=abc", my_callback)
  ###
  execute: (verb, uri, callback) ->

    options =
      host: 'api.songkick.com',
      path: "/api/3.0#{uri}",
      method: verb

    request = http.request options, (response) =>

      chunks = []

      response.on 'data', (chunk) ->
        chunks.push(chunk)

      response.on 'end', =>
        data = Buffer.concat(chunks).toString()
        json_data = JSON.parse(data)
        callback(json_data)

    request.on 'error', (err) =>
      console.log("Error: " + err)
      console.log err

    request.end()
    return undefined
