require 'open-uri'

class Feed < ActiveRecord::Base
  include ApplicationHelper

  ## Validations
  validates_presence_of :feed_url, message: "Please enter feed url."

  validates :feed_url, format: { with: /\A(http[s]?:\/\/){0,1}(www\.){0,1}[a-zA-Z0-9\.\-]+\.[a-zA-Z]{2,5}[\.]{0,1}/, message: "Please enter valid feed url."}, if: "feed_url.present?"

  validate :check_valid_rss_url, if: "feed_url.present?"

  def parse_rss_feeds
    feed_hash = {}
    doc = Nokogiri::XML(open(self.feed_url))

    items = doc.css("item")
    feed_headers = {
      title: (doc.at("title").text || ""),
      description: (doc.at("description").text || "")
    }

    items.each do |item|
      date = item.at('pubdate') || item.at('pubDate').text rescue ""
      pubdate = date.to_datetime.to_i.to_s
      feed_hash[pubdate] = create_item_hash(item, date)
    end

    feed_hash = feed_hash.sort.reverse.to_h.values
    return feed_hash, feed_headers
  end

  def create_item_hash(item, date)
    link = item.at("link") || item.at("link").next_sibling
    description = item.at("description").text.present? ? item.at("description").text : "No description found."
    hash = {
      title: item.at("title").text,
      pubdate: published_date(date),
      description: sanitize_item_description(description),
      link: link.text
    }
    return hash
  end

  private

  def check_valid_rss_url
    doc = Nokogiri::HTML(open(self.feed_url))
    self.errors.add(:feed_url, "Please enter valid RSS feed url.") if doc.css("rss").blank?
  rescue
    self.errors.add(:feed_url, "Please enter valid feed url.")
  end
end
