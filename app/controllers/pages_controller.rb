class PagesController < ApplicationController
  before_action :hide_footer, only: [:home]

  def home
    @trips = Trip.all
    if current_user
      current_trip = Trip.where(user_id:current_user).current_trip
      next_trips = Trip.where(user_id:current_user).next_trips
      past_trips = Trip.where(user_id:current_user).past_trips
      if !current_trip.empty?
        redirect_to trip_path(current_trip.first)
      elsif !next_trips.empty?
        redirect_to trip_path(next_trips.first)
      elsif !past_trips.empty?
        redirect_to trip_path(past_trips.first)
      else
        redirect_to new_trip_path
      end
    end
  end

  def index
    @trips = Trip.all
  end

  def cgu
  end

  def explanation
  end

end
