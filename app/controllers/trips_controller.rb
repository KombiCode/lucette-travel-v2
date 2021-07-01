require './app/services/sygic_api_activity_handler'

class TripsController < ApplicationController
  before_action :check_user, only: [:new]
  before_action :find_trip, only: [:show]

  def index
    @trips = Trip.all
  end

  def show
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id
    # add image if find one
    api_handler = SygicApiActivityHandler.new
    @trip.photo_title = api_handler.searchImageForCountry(@trip.country)
    if @trip.save
      redirect_to trip_firsthotel_booking_path(@trip.id)
    else
      render :new
    end
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
    render 'pages/home'
end

  private

  def find_trip
    @trip = Trip.find(params[:id])
  end

  def check_user
    if !current_user
      authenticate_user!
    end
  end

  def trip_params
    params.require(:trip).permit(:name, :country, :city, :begin_date, :end_date, :language, :devise, :description, :photo_title)
  end
end
