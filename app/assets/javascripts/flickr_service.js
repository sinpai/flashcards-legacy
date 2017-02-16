$(document).ready(function () {
    $('#load-from-link').on('click', function(e) {
        e.preventDefault();

        $('#flickr-search-block').toggle();
    });

    $('#flickr-search-button').on('click', function(e) {
        e.preventDefault();

        var query = $('#card_flickr_search_query').val();

        $.ajax({
            type: 'GET',
            url: '/flickr',
            data: { query: query },
            success: function(data) {
                $('#flickr-images-block').html(data);
            }
        });
    });


    $('#flickr-images-block').on('click', '.flickr-image', function() {
        var image_src = $(this).attr('src');

        $('#card_remote_image_url').val(image_src);
        $('#flickr-search-block').hide();

        $('#flickr-selected-image').attr('src', image_src);
        $('#flickr-selected-image-block').show();
    });
});
