require 'rails_helper'

feature 'feeds' do

  scenario 'you can visit the Index page' do
    FactoryGirl.create(:feed)
    visit root_path
    expect(page).to have_content 'http://timesofindia.indiatimes.com/rssfeedstopstories.cms'
  end

  def fill_feed_form(input)
    visit root_path
    click_link 'Add New Feed Url'
    fill_in "feed_feed_url", with: input
    click_button "Save"
  end

  scenario 'you can add a feed url' do
    fill_feed_form("http://timesofindia.indiatimes.com/rssfeedstopstories.cms")
    expect(page).to have_content('View Original Story')
  end

  scenario 'gives validation errors if feed url is empty' do
    fill_feed_form("")
    expect(page).to have_content("Please enter feed url.")
  end

  scenario 'gives validation errors for invalid feed' do
    fill_feed_form("Invalid URL")
    expect(page).to have_content("Please enter valid feed url.")
  end

  scenario 'gives validation errors if provided link does not have rss feeds.' do
    fill_feed_form("http://google.com")
    expect(page).to have_content("Please enter valid RSS feed url.")
  end

  scenario 'gives validation errors if user enters invalid or incomplete url.' do
    fill_feed_form("http://google")
    expect(page).to have_content("Please enter valid feed url.")
  end
end