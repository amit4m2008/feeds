require 'open-uri'

class Feed < ActiveRecord::Base

  ## Validations
  validates_presence_of :feed_url, message: "Please enter feed url."

  validates :feed_url, format: { with: /\A(http[s]?:\/\/){0,1}(www\.){0,1}[a-zA-Z0-9\.\-]+\.[a-zA-Z]{2,5}[\.]{0,1}/, message: "Please enter valid feed url."}, if: "feed_url.present?"

  validate :check_valid_rss_url, if: "feed_url.present?"

  def parse_rss_feeds
    feed_hash = {}
    doc = Nokogiri::XML(open(self.feed_url))
    items = doc.css("item")

    items.each do |item|
      date = item.at('pubdate') || item.at('pubDate')
      pubdate = date.text.to_datetime.to_i.to_s
      feed_hash[pubdate] = item
    end
    feed_hash = feed_hash.sort.reverse.to_h.values
    return feed_hash
  end

  private

  def check_valid_rss_url
    doc = Nokogiri::HTML(open(self.feed_url))
    self.errors.add(:feed_url, "Please enter valid RSS feed url.") if doc.css("rss").blank?
  rescue
    self.errors.add(:feed_url, "Please enter valid feed url.")
  end
end
