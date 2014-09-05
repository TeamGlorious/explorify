class TripsController < ApplicationController

  CALLBACK_URL = "http://localhost:3000/trips/callback"
  CLIENT_ID = ENV["INSTAGRAM_CLIENT_ID"]
  CLIENT_SECRET = ENV["INSTAGRAM_CLIENT_SECRET"]

  def index
    @trips_arr = []
    @trips = Trip.all
    @current_user = current_user

    # this populates the trip index with a random image from it's medias for display on the index page
    @trips.each do |trip|
      new_trip = {}
      new_trip["trip"] = trip
      if trip.medias.length > 0
        medias = trip.medias
        media = medias[rand(0..(medias.length - 1))]["thumbnail"]
        new_trip["rand_img"] = media
      end
      @trips_arr.push new_trip
      
    end
  end

  def new
    if (current_user)
      # this is the url that asks the user to log into their instagram account for data access.  With callback url.
      @url = "https://api.instagram.com/oauth/authorize/?client_id=#{CLIENT_ID}&redirect_uri=#{CALLBACK_URL}&response_type=code"
      @trip = Trip.new
    else
      redirect_to trips_path
    end
  end

  def authorize
    # OAuth code
    code = params[:code]
    # post an OAuth access token request to the instagram API server.
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
    session["instagram_user_id"] = @results["user"]["id"]
    redirect_to new_trip_path
  end

  def create

    @results_arr = []
    # Unix time 8 weeks
    two_months = 4838400

    access_token = session["access_token"]

    trip_attr = params.require(:trip).permit(:title, :description, :date_start, :date_end)

    # check for validations and other checks

    @trip = current_user.trips.create(trip_attr)

    if @trip.errors.count > 0
      @trip.errors.each do |key, value|
        error_string = "#{key} #{value}"
        error_string = error_string.slice(0, 1).capitalize + error_string.slice(1..-1)
        flash.now[:notice] = error_string
      end
    end

    if trip_attr[:date_start] != "" && trip_attr[:date_end] != "" && Date.parse(trip_attr[:date_start]).to_time.to_i > Date.parse(trip_attr[:date_end]).to_time.to_i
      flash.now[:notice] = "Your start date is later than your end date"
    end

    if flash.count > 0
      @trip.destroy
      @trip = Trip.new(trip_attr)
      render :new
    else

      # temporarily using other student's instagram id since they have more photos than I do
      shawn_id = 144837249
      steph_id = 198234099
      palmer_id = 18145159


      if @trip.date_start != "" && @trip.date_end != ""
        # limit searches to four months
        date_start = Date.parse(@trip.date_start).to_time.to_i
        date_end = Date.parse(@trip.date_end).to_time.to_i
        # if date_end - date_start > two_months * 2
        #   date_start = date_end - (two_months * 2)
        # end
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
        if (query_results["data"].length > 0)
          length = query_results["data"].length
          # Use the last returned media object's timestamp as the new date_end for time range
          date_end = query_results["data"][-1]["created_time"].to_i - 1
          @results_arr.push query_results
        else
          # instagram allows no date range, but I've limited this to a four month period.
          date_end = DateTime.now.to_time.to_i
          date_start = date_end - two_months * 2
        end

        # build each new media object
        if @results_arr.length > 0
          @results_arr.each do |results|
            results["data"].each do |media|
              media_new = @trip.medias.new
              media_new.full_res_img = media["images"]["standard_resolution"]["url"]
              media_new.med_res_img = media["images"]["low_resolution"]["url"]
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
      end
      redirect_to edit_trip_path @trip[:id]
    end
  end

  def show

  if current_user
    @current_user = current_user
    @trip = Trip.find_by_id(params[:id])
    @user = User.find_by_id(@trip.id)
    puts @current_user

    puts "HERE ARE OUR TRIPS!"
    puts @trips

  end
    @media = Media.where(trip_id:params[:id]).all
    gon.locations = @media
  end

  def edit
    if current_user && current_user[:id] == Trip.find_by_id(params[:id]).user_id
      @trip = Trip.find_by_id(params[:id])
      @medias = @trip.medias
      @current_user = current_user
    else
      redirect_to root_path
    end
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






