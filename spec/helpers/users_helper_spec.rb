require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UsersHelper, :type => :helper do
  it "Should create a new user without saving to database" do
    mike = User.new(name: "Mike", email: "me@me.com")
    expect(mike.name).to eq("Mike")
    expect(mike.new_record?).to eq(true)
  end
end
