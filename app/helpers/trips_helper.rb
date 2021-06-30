module TripsHelper
  def user_trips(user)
    Trip.where(user_id:user)
  end
end
