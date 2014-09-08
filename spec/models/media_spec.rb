require 'rails_helper'

RSpec.describe Media, :type => :model do
  it "Should create new media without saving to database" do
    media = Media.new(thumbnail: "http://mypicture.com", lat: 37.4556, lng: -122.4556)
    expect(media.thumbnail).to eq("http://mypicture.com")
    expect(media.lat).to eq(37.4556)
    expect(media.lng).to eq(-122.4556)
    expect(media.new_record?).to eq(true)
  end
end
