class ExplorifyController < ApplicationController
  def index
  end

  def new 
  end

  def create  
    @date_start = params[:date_start]
    @date_end = params[:date_end]
    redirect_to 
  end

  def show
  end

  def delete
  end
end
