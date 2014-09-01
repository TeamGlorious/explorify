class InstagramsController < ApplicationController

  CALLBACK_URL = "http://localhost:3000/instagrams/callback"
  CLIENT_ID = ENV["INSTAGRAM_CLIENT_ID"]
  CLIENT_SECRET = ENV["INSTAGRAM_CLIENT_SECRET"]

  def new
    @url = "https://api.instagram.com/oauth/authorize/?client_id=#{CLIENT_ID}&redirect_uri=#{CALLBACK_URL}&response_type=code"
    # binding.pry
  end

  def show
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

    request = Typhoeus.get(
      "https://api.instagram.com/v1/users/#{session['instagram_user_id']}/media/recent/",
      :params => {:access_token => session["access_token"]}
      )
    # binding.pry
    @results = JSON.parse(request.body)
    # binding.pry

  end

end
