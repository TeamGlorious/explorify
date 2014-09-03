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
    date_ranges = []
    seven_days = 604800

    access_token = session["access_token"]

    binding.pry
    trip_attr = params.require(:trip).permit(:title, :description, :date_start, :date_end)
    @trip = current_user.trips.create(trip_attr)

    #instagram will only return 7 day ranges per query
    if (@trip.date_start != nil && @trip.date_end != nil)
      date_start = @trip.date_start.to_time.to_i
      date_end = @trip.date_end.to_time.to_i
      date_span = date_end - date_start
      while date_span > seven_days
        date_ranges.push({date_start: date_start, date_end: date_start + seven_days})
        date_start += seven_days
        date_span -= seven_days
      end
      date_ranges.push({date_start: date_start, date_end: date_end})
    end

    # temporarily using Shawn's instagram id since he has more photos up there the rest of the team
    shawn_id = 144837249

    # binding.pry

    date_ranges.each_with_index do |range, index|
      if date_ranges.length > 1
        params = {:access_token => access_token, :max_timestamp => date_ranges[index][:date_start], :min_timestamp => date_ranges[index][:date_end]}
      else
        params = {:access_token => access_token}
      end
      request = Typhoeus.get(
        # this is the production url
        # "https://api.instagram.com/v1/users/#{session['instagram_user_id']}/media/recent/",

        # this is the Shawn specific url
        "https://api.instagram.com/v1/users/#{shawn_id}/media/recent/",
        :params => params
      )
      @results_arr.push JSON.parse(request.body)

    end

    # binding.pry
    @results_arr.each do |results|
      # binding.pry
      results["data"].each do |media|
        media_new = @trip.medias.new
        media_new.full_res_img = media["images"]["standard_resolution"]["url"]
        media_new.thumbnail = media["images"]["thumbnail"]["url"]
        if media["location"]
          # media_new.location = true
          media_new.lat = media["location"]["latitude"]
          media_new.long = media["location"]["longitude"]
        # else
        #   media_new.location = false
        end
        media_new.date_taken = DateTime.strptime(media["created_time"], '%s').to_s
        # binding.pry
        media_new.save
      end
    end

    # image = MiniMagick::Image.open(media["images"]["thumbnail"]["url"])
    # binding.pry

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













