$(document).ready(function() {
  if ($('body.location-new-js').length != 0) {

    var mapDiv;
    var map;
    var service;
    var request;

    var searched = false;

    var flickrPage;
    var flickr_url = '';
    var flickrSearch;

    var gMapsInit = false;

    function initialize() {

      mapDiv = $('#location-map-canvas')[0];

      map = new google.maps.Map(mapDiv);

      service = new google.maps.places.PlacesService(map);
        
      gMapsInit = true;
    }

    function runQuery(queryName) {
      request = {
        query: queryName
      };

      service.textSearch(request, callback);
    }

    function callback(results, status) {
      if (status == google.maps.places.PlacesServiceStatus.OK) {
        $('#location_name').val(results[0].name);
        $('#location_latitude').val(results[0].geometry.location.lat());
        $('#location_longitude').val(results[0].geometry.location.lng());
        $('.location-map').attr('src', 'http://maps.googleapis.com/maps/api/staticmap?center=' + results[0].geometry.location.lat() + ',' + results[0].geometry.location.lng() + '&zoom=16&size=200x200&markers=' + results[0].geometry.location.lat() + ',' + results[0].geometry.location.lng());
        updatePreview();
        $('.location-hidden').show();
        flickrSearch = results[0].name;
        $.getJSON('/locations/flickr.json', { search: flickrSearch }, function(data) {
          var photos = data.flickr;
          flickrPage = data.page;
          $('.flickr_photos').html('');
          for (var i = 0; i < photos.length; i++) {
            $('.flickr_photos').append('<img data-id="' + photos[i].id + '" src="' + photos[i].url + '" class="location-flickr-thumb">');
          }
          $('.flickr_more').show();
          $('.location-flickr-thumb').off('click').on('click', function () {
            $('.location-flickr-thumb.selected').removeClass('selected');
            $(this).addClass('selected');
            $('#location_clue_flickr').val($(this).attr('data-id'));
            flickr_url = $(this).attr('src');
            updatePreview();
          });
        });
        $.getJSON('/locations/wikisearch.json', { search: results[0].name }, function(data) {
          var articles = data.articles;
          $('.wiki_articles').html('');
          for (var i = 0; i < articles.length; i++) {
            $('.wiki_articles').append('<li><a href="#" data-id="' + articles[i].title + '" class="wiki_article">' + articles[i].title + '</a><br>' + articles[i].snippet + '</li>');
          }
          $('.wiki_article').off('click').on('click', function (event) {
            $.getJSON('/locations/wikitext.json', { search: $(this).attr('data-id') }, function(data) {
              $('#location_clue_wikipedia_link').val(data.url);
              $('#location_clue_wikipedia_text').val(data.text);
              updatePreview();
            });
            event.preventDefault();
          });
        });
      }
    }

    $('#getdata').on('click', function (event) {
      if (searched) {
        var confirmation1 = confirm('New searches will reset the form. Are you sure you want to continue?');
        if (confirmation1) {
            $.getJSON('/locations.json', { search: $('#query_field').val() }, function(data) {
            if (data.length > 0) {
              var confirmation2 = confirm('The similar place "' + data[0].name + '" already exists. Are you sure you want to continue?');
              if (confirmation2) {
                $('.flickr_more').hide();
                $('.location-hidden').hide();
                if (gMapsInit) {
                  runQuery($('#query_field').val());
                }
              }
            } else {
              $('.flickr_more').hide();
              $('.location-hidden').hide();
              if (gMapsInit) {
                runQuery($('#query_field').val());
              }
            }
          });
        }
      } else {
        $.getJSON('/locations.json', { search: $('#query_field').val() }, function(data) {
          if (data.length > 0) {
            var confirmation2 = confirm('The similar place "' + data[0].name + '" already exists. Are you sure you want to continue?');
            if (confirmation2) {
              $('.flickr_more').hide();
              $('.location-hidden').hide();
              if (gMapsInit) {
                runQuery($('#query_field').val());
                searched = true;
              }
            }
          } else {
            $('.flickr_more').hide();
            $('.location-hidden').hide();
            if (gMapsInit) {
              runQuery($('#query_field').val());
              searched = true;
            }
          }
        });
      }
      event.preventDefault();
    });

    $('#custom_search_flickr').on('click', function (event) {
      $('.custom_search_flickr').show();
      $('.custom_search_flickr_info').hide();
      event.preventDefault();
    });

    $('#getdata_flickr').on('click', function (event) {
      flickrSearch = $('#query_flickr_field').val();
      $.getJSON('/locations/flickr.json', { search: flickrSearch }, function(data) {
        var photos = data.flickr;
        flickrPage = data.page;
        $('.flickr_photos').html('');
        for (var i = 0; i < photos.length; i++) {
          $('.flickr_photos').append('<img data-id="' + photos[i].id + '" src="' + photos[i].url + '" class="location-flickr-thumb">');
        }
        $('.flickr_more').show();
        $('.location-flickr-thumb').off('click').on('click', function () {
          $('.location-flickr-thumb.selected').removeClass('selected');
          $(this).addClass('selected');
          $('#location_clue_flickr').val($(this).attr('data-id'));
          flickr_url = $(this).attr('src');
          updatePreview();
        });
      });
      event.preventDefault();
    });

    $('#custom_search_wiki').on('click', function (event) {
      $('.custom_search_wiki').show();
      $('.custom_search_wiki_info').hide();
      event.preventDefault();
    });

    $('#getdata_wiki').on('click', function (event) {
      $.getJSON('/locations/wikisearch.json', { search: $('#query_wiki_field').val() }, function(data) {
        var articles = data.articles;
        $('.wiki_articles').html('');
        for (var i = 0; i < articles.length; i++) {
          $('.wiki_articles').append('<li><a href="#" data-id="' + articles[i].title + '" class="wiki_article">' + articles[i].title + '</a><br>' + articles[i].snippet + '</li>');
        }
        $('.wiki_article').off('click').on('click', function (event) {
          $.getJSON('/locations/wikitext.json', { search: $(this).attr('data-id') }, function(data) {
            $('#location_clue_wikipedia_link').val(data.url);
            $('#location_clue_wikipedia_text').val(data.text);
            updatePreview();
          });
          event.preventDefault();
        });
      });
      event.preventDefault();
    });

    $('.flickr_more').on('click', function (event) {
      flickrPage += 1;
      $.getJSON('/locations/flickr.json', { search: flickrSearch, page: flickrPage }, function(data) {
        var photos = data.flickr;
        flickrPage = data.page;
        for (var i = 0; i < photos.length; i++) {
          $('.flickr_photos').append('<img data-id="' + photos[i].id + '" src="' + photos[i].url + '" class="location-flickr-thumb">');
        }
        $('.location-flickr-thumb').off('click').on('click', function () {
          $('.location-flickr-thumb.selected').removeClass('selected');
          $(this).addClass('selected');
          $('#location_clue_flickr').val($(this).attr('data-id'));
          flickr_url = $(this).attr('src');
          updatePreview();
        });
      });

      event.preventDefault();
    });

    $('input').on('change', function() {
      updatePreview();
    });

    $('textarea').on('change', function() {
      updatePreview();
    });

    function updatePreview() {
      var title = $('#location_name').val() || "Name";
      var lat = $('#location_latitude').val() || "Latitude";
      var lng = $('#location_longitude').val() || "Longitude";
      var wiki_link = $('#location_clue_wikipedia_link').val() || "Wiki Link";
      var wiki_text = $('#location_clue_wikipedia_text').val() || "Wiki Text";
      $('#location-preview-name').html(title);
      $('#location-preview-map').attr('src', 'http://maps.googleapis.com/maps/api/staticmap?center=' + lat + ',' + lng + '&zoom=16&size=200x200&markers=' + lat + ',' + lng);
      $('#location-preview-flickr-pic').attr('src', flickr_url);
      $('#location-preview-wiki-link').html(wiki_link);
      $('#location-preview-wiki-text').html(wiki_text);
    }

    initialize();
    updatePreview();
  }
});
