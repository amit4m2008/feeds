require 'open-uri'

class Feed < ActiveRecord::Base
  ## Validations
  validates_presence_of :feed_url

  def parse_rss_feeds
    feed_hash = {}
    doc = Nokogiri::HTML(open(self.feed_url))
    items = doc.css("item")

    items.each do |item|
      pubdate = item.at('pubdate').text.to_datetime.to_i.to_s
      feed_hash[pubdate] = item
    end
    feed_hash = feed_hash.sort.reverse.to_h.values
    return feed_hash
  end

end
