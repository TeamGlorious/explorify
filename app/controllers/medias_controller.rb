class MediasController < ApplicationController
  def edit
    @trip = Trip.find_by_id(params[:trip_id])
    @media = Media.find_by_id(params[:id])
  end

  def update
  end

  def destroy
    media = Media.find_by_id(params[:id])
    # binding.pry
    media.destroy
    redirect_to edit_trip_path Trip.find_by_id(params[:trip_id])
  end
end
