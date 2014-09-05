class MediasController < ApplicationController
  def edit
    if (current_user && current_user[:id] != params[:user_id])
      @trip = Trip.find_by_id(params[:trip_id])
      @media = Media.find_by_id(params[:id])
    end
    redirect_to root_path
  end

  def update
    trip = Trip.find_by_id(params[:trip_id])
    media_attr = params.require(:media).permit(:latitude, :longitude, :date_taken)

    media_attr[:date_taken] = Date.parse(media_attr[:date_taken]).to_time.to_s

    media_to_update = Media.find_by_id(params[:id])
    media = media_to_update.update_attributes(media_attr)

    redirect_to edit_trip_path trip
  end

  def destroy
    media = Media.find_by_id(params[:id])
    media.destroy
    redirect_to edit_trip_path Trip.find_by_id(params[:trip_id])
  end
end
