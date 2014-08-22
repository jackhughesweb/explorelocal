$(document).ready(function() {
  if ($('body.game-js').length != 0) {

    var gameData;
    var markers = [];
    var markersGuess = [];
    var currentScore = 0;
    var currentLevel = 1;
    var guessLatLng;
    var map;
    var mapGuess;

    function initialize() {

      var curLat = 0;
      var curLng = 0;

      var mapStyle = [{
        "featureType": "poi", 
        "stylers": [{ "visibility": "off" }] 
      }];

      var mapOptions = {
        center: new google.maps.LatLng(curLat, curLng),
        zoom: 1,
        disableDefaultUI: true
      };

      map = new google.maps.Map(document.getElementById("map-canvas"),
          mapOptions);

      map.setOptions({styles: mapStyle});

      mapGuess = new google.maps.Map(document.getElementById("map-canvas-guess"),
          mapOptions);

      mapGuess.setOptions({styles: mapStyle});

      google.maps.event.addListener(map, 'click', function(event) {
        for (var i = 0; i < markers.length; i++) {
          markers[i].setMap(null);
        }

        markers = [];

        var marker = new google.maps.Marker({
            position: event.latLng,
            animation: google.maps.Animation.DROP,
            map: map
        });

        guessLatLng = event.latLng;

        markers.push(marker);

        $('.pinbutton').slideDown();
        $('.pininfo').slideUp();
      });


      function updateMap(newLat, newLong) {
        var myLatLng = new google.maps.LatLng(newLat, newLong);
        map.setCenter(myLatLng);
      }

      $.get(window.location.pathname + '.json', function(data){
        gameData = data;
        resetMap();
        updateClues(gameData.locations[0]);
        $('.not-loading').show();
        $('.loading').hide();         
      });
    }

    google.maps.event.addDomListener(window, 'load', initialize);

    // Following distanceFrom code from studiowhiz.com/2010/10/02/google-maps-v3-distancefrom/
    // to replace the removal after APi v2 to v3 removal
    /**
    * @param {google.maps.LatLng} newLatLng
    * @returns {number}
    */
    google.maps.LatLng.prototype.distanceFrom = function(newLatLng) {
       // setup our variables
       var lat1 = this.lat();
       var radianLat1 = lat1 * ( Math.PI  / 180 );
       var lng1 = this.lng();
       var radianLng1 = lng1 * ( Math.PI  / 180 );
       var lat2 = newLatLng.lat();
       var radianLat2 = lat2 * ( Math.PI  / 180 );
       var lng2 = newLatLng.lng();
       var radianLng2 = lng2 * ( Math.PI  / 180 );
       // sort out the radius, MILES or KM?
       var earth_radius = 3959; // (km = 6378.1) OR (miles = 3959) - radius of the earth
     
       // sort our the differences
       var diffLat =  ( radianLat1 - radianLat2 );
       var diffLng =  ( radianLng1 - radianLng2 );
       // put on a wave (hey the earth is round after all)
       var sinLat = Math.sin( diffLat / 2  );
       var sinLng = Math.sin( diffLng / 2  ); 
     
       // maths - borrowed from http://www.opensourceconnections.com/wp-content/uploads/2009/02/clientsidehaversinecalculation.html
       var a = Math.pow(sinLat, 2.0) + Math.cos(radianLat1) * Math.cos(radianLat2) * Math.pow(sinLng, 2.0);
     
       // work out the distance
       var distance = earth_radius * 2 * Math.asin(Math.min(1, Math.sqrt(a)));
     
       // return the distance
       return distance;
    }


    function updateClues(currentLocationData) {
      $('.clue-flickr-image').attr('src', currentLocationData.flickr_url);
      $('.clue-place-name').text(currentLocationData.name);
      $('.clue-wikipedia-clue').text(currentLocationData.clue_wikipedia_text);
    }

    $('.clue.card').on('click', function() {
      $(this).children('h2').children('.clue-icon-open').show();
      $(this).children('h2').children('.clue-icon-closed').hide();
      $(this).children('.hidden').slideDown();
      $(this).children('.tohide').slideUp();
      $(this).removeClass('clickable');
    });

    $('.clue-flickr-image').on('click', function() {
      $('.lightbox').show();
    });

    $('.lightbox').on('click', function() {
      $('.lightbox').hide();
    });

    $('.pinbutton').on('click', function() {
      var correctLatLng = new google.maps.LatLng(gameData.locations[currentLevel - 1].latitude, gameData.locations[currentLevel - 1].longitude);
      var miledistance = correctLatLng.distanceFrom(guessLatLng, 3959).toFixed(1);
      $('.modal-miles').text(miledistance);
      $('.modal-points').text(getScoreFromMiles(miledistance, gameData.radius));
      $('.modal-clue-points').text(getCluePoints());
      $('.modal-level-points').text(getScoreFromMiles(miledistance, gameData.radius) - getCluePoints());
      currentScore += getScoreFromMiles(miledistance, gameData.radius);
      currentScore -= getCluePoints();
      updateScreen();
      $('.modal-current-score').text(currentScore);
      if (currentLevel == 4) {
        $('.modal-next-level').html('Next &rarr;');
      }
      $('.lightbox-modal').show();
      google.maps.event.trigger(mapGuess, "resize");
      for (var i = 0; i < markersGuess.length; i++) {
        markersGuess[i].setMap(null);
      }
      markersGuess = [];
      var markerGuess1 = new google.maps.Marker({
          position: guessLatLng,
          map: mapGuess
      });
      markersGuess.push(markerGuess1);
      var circ = new google.maps.Circle();
      circ.setRadius(miledistance * 1609.0);
      circ.setCenter(guessLatLng);
      mapGuess.fitBounds(circ.getBounds());
      mapGuess.setCenter(guessLatLng);
      var mapPath = new google.maps.Polyline({
        path: [guessLatLng, correctLatLng],
        geodesic: true,
        strokeColor: '#FF0000',
        strokeOpacity: 1.0,
        strokeWeight: 2
      });
      markersGuess.push(mapPath);
      mapPath.setMap(mapGuess);

    });

    $('.modal-info-start').on('click', function() {
      $('.lightbox-modal-info').hide();
    });

    $('.modal-next-level').on('click', function() {
      if (currentLevel == 4) {
        $('.modal-end-final-score').text(currentScore);
        loadAward();

        for (var i = 4; i >= 1; i--) {
          var location = gameData.locations[i - 1];
          $('.location-data-' + i).children('h2.name').text(location.name);
          $('.location-data-' + i).children('div.location-container').children('p').children('img.image').attr('src', location.flickr_url);
          $('.location-data-' + i).children('div.location-container').children('p').children('a.image-link').attr('href', location.flickr_page);
          $('.location-data-' + i).children('div.location-container').children('div.text').text(location.clue_wikipedia_text.replace(/\[(T|t)he location\]/g, location.name));
          $('.location-data-' + i).children('div.location-container').children('div.text').append(" <a href='" + location.clue_wikipedia_link + "'>More on Wikipedia...</a>");
          $('.location-data-' + i).children('h2.name').on('click', function() {
            $(this).parent().children('div.location-container').slideToggle();
          });
          $('.location-data-' + i).children('div.location-container').hide();
        };

        $('.twitter-score').attr('href', 'https://twitter.com/intent/tweet?related=jackhughesweb&text=I%20just%20scored%20' + currentScore + '%20on%20ExploreLocal!%20Beat%20my%20score%20at%20' + window.location.href + '%20%23explorelocal&original_referer=URL#tweet-intent');
        $('.lightbox-modal-end').show();
        $('.lightbox-modal').hide();
      } else {
        currentLevel += 1;
        $('.clue.card').children('.hidden').hide();
        $('.clue.card').children('.tohide').show();
        $('.clue.card').addClass('clickable');
        $('.clue-icon-closed').show();
        $('.clue-icon-open').hide();
        updateClues(gameData.locations[currentLevel - 1]);
        $('.pinbutton').hide();
        $('.pininfo').show();
        for (var i = 0; i < markers.length; i++) {
          markers[i].setMap(null);
        }
        markers = [];
        resetMap();
        updateScreen();
        $('.lightbox-modal').hide();
      }
    });

    function getScoreFromMiles(miles, maxMiles) {
      if (miles >= maxMiles) {
        return Math.round(100);
      } else {
        return Math.round(100 + (((maxMiles - miles)/maxMiles) * 900));
      }
    }

    function loadAward() {
      if (currentScore < 1000) {
        $('.award-none').show();
        $('.award-info').text('You didn\'t manage to win an award this time. Why not try this level again? (You need 1000 points to get the bronze award)');
      }
      if (currentScore >= 1000 && currentScore < 2200) {
        $('.award-bronze').show();
        $('.award-info').text('You won the bronze award! Keep up the good work! (You need 2200 points to get the silver award)');
      }
      if (currentScore >= 2200 && currentScore < 3200) {
        $('.award-silver').show();
        $('.award-info').text('You won the silver award! You\'re not far from winning the gold award now! (You need 3200 points to get the gold award)');
      }
      if (currentScore >= 3200) {
        $('.award-gold').show();
        $('.award-info').text('You won the gold award! Now try another new game or even challenge your friends!');
      }
    }

    function getCluePoints() {
      var returnVal = 0;
      if ($('.wiki-clue.clickable').length == 0) {
        returnVal += 50;
      }
      if ($('.name-clue.clickable').length == 0) {
        returnVal += 100;
      }
      return returnVal;
    }

    function updateScreen() {
      $('.score-current').text(currentScore);
      $('.level-current').text(currentLevel);
    }

    function resetMap() {
      var circ = new google.maps.Circle();
      var latlng = new google.maps.LatLng(gameData.latitude, gameData.longitude);
      circ.setRadius(gameData.radius * 1609.0);
      circ.setCenter(latlng);
      map.setCenter(latlng);
      map.fitBounds(circ.getBounds());
    }

    updateScreen();
  }
});
