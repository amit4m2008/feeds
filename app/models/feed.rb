require 'open-uri'

class Feed < ActiveRecord::Base
  ## Validations
  validates_presence_of :feed_url

  def parse_rss_feeds
    doc = Nokogiri::HTML(open(self.feed_url))
    items = doc.css("rss channel item")
    return items
  end
end
