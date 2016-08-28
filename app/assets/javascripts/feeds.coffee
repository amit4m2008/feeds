# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $('#save_feed').click ->
    url_regexe = /^(http[s]?:\/\/){0,1}(www\.){0,1}[a-zA-Z0-9\.\-]+\.[a-zA-Z]{2,5}[\.]{0,1}/
    feed_url_input = $('#feed_feed_url')
    feed_url_label = feed_url_input.closest('div.form-group').find('label')
    error_div_wrapper = '<div class=\'field_with_errors\'></div>'
    error_explanation_div = $('#error_explanation')
    error_body = '<h5>Please correct the following errors</h5><ul><li></li></ul>'
    feed_url = feed_url_input.val()

    if feed_url.length == 0
      $(error_explanation_div).html error_body
      $(error_explanation_div).find('li').text 'Please enter feed url.'
      $(feed_url_input).wrap error_div_wrapper
      $(feed_url_label).wrap error_div_wrapper
      false
    else if !url_regexe.test(feed_url)
      $(error_explanation_div).html error_body
      $(error_explanation_div).find('li').text 'Please enter valid feed url.'
      $(feed_url_input).wrap error_div_wrapper
      $(feed_url_label).wrap error_div_wrapper
      false
    else
      if !/^(https?|ftp):\/\//i.test(feed_url)
        url = 'http://' + feed_url
        $(feed_url_input).val url
      true