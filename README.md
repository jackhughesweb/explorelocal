ExploreLocal [![Dependency Status](https://gemnasium.com/jackhughesweb/explorelocal.svg)](https://gemnasium.com/jackhughesweb/explorelocal) [![Code Climate](https://codeclimate.com/github/jackhughesweb/explorelocal/badges/gpa.svg)](https://codeclimate.com/github/jackhughesweb/explorelocal) [![Inline docs](http://inch-ci.org/github/jackhughesweb/explorelocal.png?branch=master)](http://inch-ci.org/github/jackhughesweb/explorelocal)
========

ExploreLocal is a game for discovering and identifying nearby places of interest. Users are presented with clues from sources such as Wikipedia and Flickr and they then have to guess where the place is. Points are gained from accurately choosing the correct location and points are deducted for using more clues. At the end of the game, users receive an award and have the option of challenging their friends using social media.

To setup ExploreLocal in a development environment, you will need to set the `El_SECRET`, `EL_FLICR`, `EL_FLICKR_SECRET` environment variables to `rake secret`, a Flickr API key and Flickr API secret respectively. Also, please change the Google Analytics ID and Google Maps JS API key to your own.
