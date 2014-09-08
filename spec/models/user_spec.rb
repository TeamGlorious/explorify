require 'rails_helper'

RSpec.describe User, :type => :model do

  it "Should create a new user without saving to database" do
    mike = User.new(name: "Mike", email: "me@me.com")
    expect(mike.name).to eq("Mike")
    expect(mike.new_record?).to eq(true)
  end

  subject { FactoryGirl.create(:user) }

  it "should have a valid factory" do
    expect(subject).to be_valid
  end

end


