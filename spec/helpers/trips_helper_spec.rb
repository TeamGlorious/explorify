require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TripsHelper. For example:
#
# describe TripsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TripsHelper, :type => :helper do
  it "Should create a new trip without saving to database" do
    trip = Trip.new(title: "My Trip", date_start: "2013-01-01", date_end: "2013-01-14")
    expect(trip.title).to eq("My Trip")
    expect(trip.date_start).to eq("2013-01-01")
    expect(trip.date_end).to eq("2013-01-14")
    expect(trip.new_record?).to eq(true)
  end
end
