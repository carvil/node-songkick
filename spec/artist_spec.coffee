nock      = require 'nock'
fs        = require 'fs'
Songkick  = require "../lib/node-songkick"

sk = new Songkick("myapikey")

describe "Songkick", ->

  describe "Artist search", ->

    describe "given a valid search for an artist is returned", ->
      beforeEach ->
        placebo = nock('http://api.songkick.com/')
          .get('/api/3.0/search/artists.json?query=placebo&apikey=myapikey&per_page=50&page=1')
          .replyWithFile(200, __dirname + '/fixtures/search_success.json')

      it "should return the total number of entries", (done) ->
        sk.artist.search("placebo", {}, (result) ->
          expect(result.resultsPage.status).toEqual('ok')
          expect(result.resultsPage.totalEntries).toEqual(15)
          expect(result.resultsPage.perPage).toEqual(50)
          expect(result.resultsPage.page).toEqual(1)
          expect(result.resultsPage.results.artist[0].displayName).toEqual("Placebo")
          expect(result.resultsPage.results.artist[0].id).toEqual(324967)
          expect(result.resultsPage.results.artist[0].onTourUntil).toEqual("2012-09-22")
          expect(result.resultsPage.results.artist[0].uri).toEqual("http://www.songkick.com/artists/324967-placebo?utm_source=14303&utm_medium=partner")
          done()
        )

    describe "when searching for a non-existing artist", ->
      beforeEach ->
        carvil = nock('http://api.songkick.com/')
          .get('/api/3.0/search/artists.json?query=carvil&apikey=myapikey&per_page=50&page=1')
          .replyWithFile(200, __dirname + '/fixtures/search_not_found.json')

      it "should return the empty results", (done) ->
        sk.artist.search("carvil", {}, (result) ->
          expect(result.resultsPage.results).toEqual({})
          expect(result.resultsPage.status).toEqual('ok')
          expect(result.resultsPage.totalEntries).toEqual(0)
          expect(result.resultsPage.perPage).toEqual(50)
          expect(result.resultsPage.page).toEqual(1)
          done()
        )

  describe "Calendar search", ->

    describe "given a valid search for an artist's calendar", ->
      beforeEach ->
        calendar = nock('http://api.songkick.com/')
          .get('/api/3.0/artists/324967/calendar.json?apikey=myapikey&per_page=50&page=1')
          .replyWithFile(200, __dirname + '/fixtures/calendar_success.json')

      it "should return the calendar data", (done) ->
        sk.artist.calendar("artist_id", 324967, {}, (result) ->
          expect(result.resultsPage.status).toEqual('ok')
          expect(result.resultsPage.totalEntries).toEqual(7)
          expect(result.resultsPage.perPage).toEqual(50)
          expect(result.resultsPage.page).toEqual(1)
          expect(result.resultsPage.results.event[0].displayName).toEqual("Rock en Seine 2012")
          expect(result.resultsPage.results.event[0].id).toEqual(12166218)
          done()
        )

    describe "given an invalid type", ->

      it "should return an error message", (done) ->
        sk.artist.calendar("invalid", 0, {}, (result) ->
          expect(result).toEqual({ error: 'Unknown type: must be artist_id or music_brainz_id' })
          done()
        )

    describe "given a search by a valid music_brainz_id", ->
      beforeEach ->
        calendar = nock('http://api.songkick.com/')
          .get('/api/3.0/artists/mbid:cc197bad-dc9c-440d-a5b5-d52ba2e14234/calendar.json?apikey=myapikey&per_page=50&page=1')
          .replyWithFile(200, __dirname + '/fixtures/calendar_by_musicbrainz.json')

      it "should return events' data", (done) ->
        sk.artist.calendar("music_brainz_id", "cc197bad-dc9c-440d-a5b5-d52ba2e14234", {}, (result) ->
          expect(result.resultsPage.status).toEqual('ok')
          expect(result.resultsPage.totalEntries).toEqual(22)
          expect(result.resultsPage.perPage).toEqual(50)
          expect(result.resultsPage.page).toEqual(1)
          expect(result.resultsPage.results.event[0].popularity).toEqual(1)
          expect(result.resultsPage.results.event[0].displayName).toEqual('Coldplay with Marina and the Diamonds and Punky the Singer at Parken (August 28, 2012)')
          expect(result.resultsPage.results.event[0].type).toEqual('Concert')
          done()
        )

    describe "given a search by an invalid id", ->
      beforeEach ->
        calendar = nock('http://api.songkick.com/')
          .get('/api/3.0/artists/mbid:invalid/calendar.json?apikey=myapikey&per_page=50&page=1')
          .replyWithFile(200, __dirname + '/fixtures/calendar_invalid_musicbrainz.json')

      it "should return an empty object", (done) ->
        sk.artist.calendar("music_brainz_id", "invalid", {}, (result) ->
          expect(result.resultsPage.results).toEqual({})
          expect(result.resultsPage.status).toEqual('ok')
          expect(result.resultsPage.totalEntries).toEqual(0)
          expect(result.resultsPage.perPage).toEqual(50)
          expect(result.resultsPage.page).toEqual(1)
          done()
        )

  describe "Gigography search", ->

    describe "given an invalid type", ->

      it "should return an error message", (done) ->
        sk.artist.gigography("invalid", 0, {}, (result) ->
          expect(result).toEqual({ error: 'Unknown type: must be either artist_id or music_brainz_id' })
          done()
        )

    describe "given a valid search for an artist's gigography by artist_id", ->
      beforeEach ->
        calendar = nock('http://api.songkick.com/')
          .get('/api/3.0/artists/324967/gigography.json?apikey=myapikey&per_page=50&page=1')
          .replyWithFile(200, __dirname + '/fixtures/gigography_success.json')

      it "should return the gigography_success data", (done) ->
        sk.artist.gigography("artist_id", 324967, {}, (result) ->
          expect(result.resultsPage.status).toEqual('ok')
          expect(result.resultsPage.totalEntries).toEqual(958)
          expect(result.resultsPage.perPage).toEqual(50)
          expect(result.resultsPage.page).toEqual(1)
          expect(result.resultsPage.results.event[0].displayName).toEqual("Placebo with Nameshaker at The Rock Garden (January 23, 1995)")
          expect(result.resultsPage.results.event[0].id).toEqual(937131)
          done()
        )

    describe "given a search by an invalid id", ->
      beforeEach ->
        calendar = nock('http://api.songkick.com/')
          .get('/api/3.0/artists/invalid/gigography.json?apikey=myapikey&per_page=50&page=1')
          .replyWithFile(200, __dirname + '/fixtures/gigography_invalid_musicbrainz.json')

      it "should return an empty object", (done) ->
        sk.artist.gigography("artist_id", "invalid", {}, (result) ->
          expect(result.resultsPage.results).toEqual({})
          expect(result.resultsPage.status).toEqual('ok')
          expect(result.resultsPage.totalEntries).toEqual(0)
          expect(result.resultsPage.perPage).toEqual(50)
          expect(result.resultsPage.page).toEqual(1)
          done()
        )
