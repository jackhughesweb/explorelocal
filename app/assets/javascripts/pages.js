$(document).ready(function() {
  $('.game-new-location-button').on('click', function(event) {
    if ("geolocation" in navigator) {
      $('.game-new-location-button').text('Locating...');
      navigator.geolocation.getCurrentPosition(function(position) {
        var latitude  = position.coords.latitude;
        var longitude = position.coords.longitude;
        var geocoder = new google.maps.Geocoder();
        var location = new google.maps.LatLng(latitude,longitude);

        geocoder.geocode({ 'latLng': location }, function(results, status) {
          if (status == google.maps.GeocoderStatus.OK) {
              $('#game_new_location').val(results[3].formatted_address);
              checkGame();
              $('.game-new-location-button').text('Located');
          } else {
            $('.game-new-location-button').text('Error');
          }
        });
      }, function() {
        $('.game-new-location-button').text('Error');
      });
    } else {
      $('.game-new-location-button').text('Not supported');
    }
    event.preventDefault();
  });

  function checkGame() {
    $('#game-start').text('Checking...');
    $('#game-start').prop('disabled', true );
    $.get('/games/check_game.json', {
      "game_new_location": $('#game_new_location').val(),
      "game_new_radius": $('#game_new_radius').val(),
    }, function(data){
      if (!data.message) {
        $('#game-start').text('Not enough locations found');
        $('#game-start').prop('disabled', true);
      } else {
        $('#game-start').text('Start game');
        $('#game-start').prop('disabled', false);
      }
    });
  }

  $('input.game-new-form').on('change', function() {
    checkGame();
  });
});
