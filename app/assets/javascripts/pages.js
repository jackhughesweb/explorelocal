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
        $('.game-new-report-info').show();
      } else {
        $('#game-start').text('Start game');
        $('#game-start').prop('disabled', false);
        $('.game-new-report-info').hide();
      }
    });
  }

  $('input.game-new-form').on('change', function() {
    checkGame();
  });

  $('.game-new-report-link').on('click', function(event) {
    $('#game-report-location').val($('#game_new_location').val());
    $('#game-report-radius').val($('#game_new_radius').val());
    $('#game-report-submit').text('Submit');
    $('#game-report-submit').prop('disabled', false);
    $('.lightbox-modal-game-report').show();
    event.preventDefault();
  });

  $('.game-new-report-back').on('click', function(event) {
    $('.lightbox-modal-game-report').hide();
    $('.lightbox-modal-game-report-done').hide();
    event.preventDefault();
  });

  $('#game-report-submit').on('click', function() {
    $('#game-report-submit').text('Sending report...');
    $('#game-report-submit').prop('disabled', true);
    $.ajax({
      url: '/games/report',
      type: 'post',
      data: {
        "game_report_location": $('#game-report-location').val(),
        "game_report_radius": $('#game-report-radius').val(),
        "game_report_message": $('#game-report-message').val(),
        "game_report_name": $('#game-report-name').val(),
        "game_report_email": $('#game-report-email').val()
      },
      success: function(result) {
        $('#game-report-submit').text('Sent');
        $('.lightbox-modal-game-report').hide();
        $('.lightbox-modal-game-report-done').show();
      },
      error: function(result) {
        $('#game-report-submit').text('Error - click to retry');
        $('#game-report-submit').prop('disabled', false);
      }
    });
  });
});
