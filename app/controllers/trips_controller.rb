class TripsController < ApplicationController

  require 'open-uri'

  CALLBACK_URL = "http://localhost:3000/trips/callback"
  CLIENT_ID = ENV["INSTAGRAM_CLIENT_ID"]
  CLIENT_SECRET = ENV["INSTAGRAM_CLIENT_SECRET"]

  def index
    @trips_arr = []
    @trips = Trip.all

    # this populates the trip index with a random image from it's media
    @trips.each do |trip|
      new_trip = {}
      new_trip["trip"] = trip
      if trip.medias.length > 0
        medias = trip.medias
        media = medias[rand(0..(medias.length - 1))]["thumbnail"]
        new_trip["rand_img"] = media
      end
      @trips_arr.push new_trip
      # binding.pry
    end
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
    @results_arr = []
    # Unix time 8 weeks
    two_months = 4838400

    access_token = session["access_token"]

    trip_attr = params.require(:trip).permit(:title, :description, :date_start, :date_end)
    @trip = current_user.trips.create(trip_attr)

    # temporarily using other student's instagram id since they have more photos than I do
    shawn_id = 144837249
    steph_id = 198234099
    palmer_id = 18145159


    if @trip.date_start != "" && @trip.date_end != ""
      date_start = Date.parse(@trip.date_start).to_time.to_i
      date_end = Date.parse(@trip.date_end).to_time.to_i
    else
      # instagram allows no date range, but I've limited this to a two month period.
      date_end = DateTime.now.to_time.to_i
      date_start = date_end - two_months
    end
    
    # Instagram has a hard cap of 33 media returned per query.
    # This loop does multiple queries to get all of the media during a time frame
    length = 33
    while length >= 33
      params = {:access_token => access_token, :count => 100, :min_timestamp => date_start, :max_timestamp => date_end}
      request = Typhoeus.get(
        # this is the production url
        # "https://api.instagram.com/v1/users/#{session['instagram_user_id']}/media/recent/",

        # this is the Shawn specific url
        "https://api.instagram.com/v1/users/#{shawn_id}/media/recent/",
        :params => params
      )
      query_results = JSON.parse(request.body)
      # binding.pry
      if (query_results["data"].length > 0)
        length = query_results["data"].length
        # Use the last returned media object's timestamp as the new date_end for time range
        date_end = query_results["data"][-1]["created_time"].to_i - 1
        @results_arr.push query_results
      else
        length = 0
      end
  
      # build each new media object
      if @results_arr.length > 0
        @results_arr.each do |results|
          results["data"].each do |media|
            media_new = @trip.medias.new
            media_new.full_res_img = media["images"]["standard_resolution"]["url"]
            media_new.thumbnail = media["images"]["thumbnail"]["url"]
            if media["location"]
              # media_new.location = true
              media_new.lat = media["location"]["latitude"]
              media_new.lng = media["location"]["longitude"]
              media_new.date_taken = DateTime.strptime(media["created_time"], '%s').to_s
              # moved this here so that only photos with location data are processed.  Temporary fix.
              media_new.save
            end
          end
        end
      end

    # image = MiniMagick::Image.open(media["images"]["thumbnail"]["url"])
    # binding.pry
    end
    redirect_to edit_trip_path @trip[:id]
  end

  def show

  end

  def edit
    @trip = Trip.find_by_id(params[:id])
    @medias = @trip.medias
  end

  def update
  end

  def destroy
    @trip = Trip.find_by_id(params[:id])
    @user = User.find_by_id(@trip.user_id)
    medias = @trip.medias
    medias.each do |media|
      media.destroy
    end
    @trip.destroy

    redirect_to @user
  end
end






