# node-songkick

[![Build Status](https://secure.travis-ci.org/carvil/node-songkick.png)](http://travis-ci.org/carvil/node-songkick)

A node.js wrapper around [songkick's](http://www.songkick.com) [API](http://www.songkick.com/developer).

## Installation

You can use [npm](https://npmjs.org) to install this module:

    npm install node-songkick

If you prefer to use the source form github, clone the repo:

    git clone https://github.com/carvil/node-songkick.git

## Usage

After installing/cloning the module, you can open a node console:

    node

and require the module:

    var Songkick = require("node-songkick");

If you cloned the repo, use this instead:

    var Songkick = require("<PATH-TO-node-songkick>");

And create an instance of `Songkick`:

    var sk = new Songkick("<YOUR API KEY>");

You can request an API key at songkick's [website](http://www.songkick.com/api_key_requests/new).

After creating an instance, it is possible to query information about artists. More to come in the future (venue, location, events)

### Artist

#### Search

Assuming there is a `sk` object, it is possible to search for artists:

    sk.artist.search("joe bonamassa", { page: 1, per_page: 25 }, callback)

The params are:

1. The query string;
2. A hash of options: `per_page` and `page`, besides the `api key` and `query string` already present;
3. A callback function, which will handle the results.

An example:

    > sk.artist.search("muse",{},function(r) { console.log(r); } )
    > { resultsPage:
       { results: { artist: [Object] },
         totalEntries: 0,
         perPage: 50,
         page: 1,
         status: 'ok' } }

The `results` object will contain a number of results. More examples in `specs/fixtures`.

#### Calendar

Assuming there is a `sk` object, it is possible to search for an artist's calendar:

    sk.artist.calendar("artist_id", 324967,{ per_page: 10, page: 1 }, callback )

The params are:

1. The type of the id used: `artist_id` or `music_brainz_id`;
2. The actual id;
2. A hash of options: `per_page` and `page`, besides the `api key` and `query string` already present;
3. A callback function, which will handle the results.

An example:

    > sk.artist.calendar("artist_id", 324967, { per_page: 10 }, function(r) { console.log(r);} )
    > { resultsPage:
       { results: { event: [Object] },
         totalEntries: 5,
         perPage: 10,
         page: 1,
         status: 'ok' } }

The `results` object will contain a number of results. More examples in `specs/fixtures`.

#### Gigography

Assuming there is a `sk` object, it is possible to search for an artist's gigography:

    sk.artist.gigography("artist_id", 324967, { per_page: 5, page: 2 }, callback )

The params are:

1. The type of the id used: `artist_id` or `music_brainz_id`;
2. The actual id;
2. A hash of options: `per_page` and `page`, besides the `api key` and `query string` already present;
3. A callback function, which will handle the results.

An example:

    > sk.artist.gigography("artist_id", 324967,{ per_page: 10, page: 2 }, function(r) { console.log(r);} )
    > { resultsPage:
       { results: { event: [Object] },
         totalEntries: 961,
         perPage: 10,
         page: 2,
         status: 'ok' } }

The `results` object will contain a number of results. More examples in `specs/fixtures`.

## Testing

In order to run the tests, clone the repo:

    git clone https://github.com/carvil/node-songkick.git
    cd node-songkick

Install dependencies:

    npm install

And the run:

    jasmine-node --coffee --verbose ./spec/

## TODO

- Venues
- Events
- Metro areas
- Users

## Submitting a Pull Request

1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Add specs for your unimplemented feature or bug fix.
4. Run `jasmine-node --coffee --verbose ./spec/`. If your specs pass, return to step 3.
5. Implement your feature or bug fix.
6. Run `jasmine-node --coffee --verbose ./spec/`. If your specs fail, return to step 5.
7. Add documentation for your feature or bug fix.
8. Add, commit, and push your changes.
9. [Submit a pull request.][pr]

[fork]: http://help.github.com/fork-a-repo/
[branch]: http://learn.github.com/p/branching.html
[pr]: http://help.github.com/send-pull-requests/

## Supported node versions

I only tested this module on node `0.8.0`, therefore I don't know if it will work on previous/more recent
versions. Please let me know if you tried it and if it worked/didn't work.

## Disclaimer

This was the first time I wrote a `node` module. If you find stuff that could be improved or done
differently/in a better way, I would love to hear from you. Feel free to DM me on [twitter](https://twitter.com/carvil_) or
send me a pull request!

## Copyright

Copyright (c) 2012 Carlos Vilhena. See [LICENSE](https://github.com/carvil/node-songkick/blob/master/LICENSE) for details.
