module ApplicationHelper
  def sanitize_item_description(text)
    return ActionView::Base.full_sanitizer.sanitize(text).squish rescue ""
  end

  def published_date(date_string)
    return date_string.to_datetime.strftime("%a, %d %b %Y %H:%M:%S") rescue ""
  end
end
