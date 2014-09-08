require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the MediasHelper. For example:
#
# describe MediasHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe MediasHelper, :type => :helper do
  it "Should create new media without saving to database" do
    media = Media.new(thumbnail: "http://mypicture.com", lat: 37.4556, lng: -122.4556)
    expect(media.thumbnail).to eq("http://mypicture.com")
    expect(media.lat).to eq(37.4556)
    expect(media.lng).to eq(-122.4556)
    expect(media.new_record?).to eq(true)
  end
end
