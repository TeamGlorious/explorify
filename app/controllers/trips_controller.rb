class TripsController < ApplicationController

  require 'open-uri'

  CALLBACK_URL = "http://localhost:3000/trips/callback"
  CLIENT_ID = ENV["INSTAGRAM_CLIENT_ID"]
  CLIENT_SECRET = ENV["INSTAGRAM_CLIENT_SECRET"]

  def index
    @trips = Trip.all
  end

  def new
    @url = "https://api.instagram.com/oauth/authorize/?client_id=#{CLIENT_ID}&redirect_uri=#{CALLBACK_URL}&response_type=code"
    @trip = Trip.new
  end

  def authorize
    code = params[:code]  
    request = Typhoeus::Request.new(
      "https://api.instagram.com/oauth/access_token",
      method: :post,
      body: { :client_id => CLIENT_ID,
              :client_secret => CLIENT_SECRET,
              :grant_type => "authorization_code",
              :redirect_uri => CALLBACK_URL,
              :code => code }
      )
    @results = JSON.parse((request.run).body)
    session["access_token"] = @results["access_token"]
    # binding.pry
    session["instagram_user_id"] = @results["user"]["id"]
    redirect_to new_trip_path
  end

  def create
    # binding.pry
    trip_attr = params.require(:trip).permit(:title, :description, :date_start, :date_end)
    @trip = current_user.trips.create(trip_attr)
    # binding.pry
    redirect_to @trip
  end

  def show
    access_token = session["access_token"]
    @trip = Trip.find_by_id(params[:id])
    if (@trip.date_start != nil && @trip.date_end != nil)
      date_start = @trip.date_start.to_time.to_i
      date_end = @trip.date_end.to_time.to_i
      params = {:access_token => access_token, :max_timestamp => date_start, :min_timestamp => date_end}
    else
      params = {:access_token => @access_token}
    end

    shawn_id = 144837249

    request = Typhoeus.get(
      # "https://api.instagram.com/v1/users/#{session['instagram_user_id']}/media/recent/",
      "https://api.instagram.com/v1/users/#{shawn_id}/media/recent/",
      :params => params
      )
    # binding.pry
    @results = JSON.parse(request.body)
    @timestamps = []
    @results["data"].each do |media|
      require 'open-uri'

      # image = MiniMagick::Image.open(media["images"]["thumbnail"]["url"])
      # binding.pry
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
