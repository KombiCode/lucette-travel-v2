class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :trips
  has_one :current_trip, -> { current_trip }, class_name: 'Trip'
  has_one :next_trips, -> { next_trips }, class_name: 'Trip'
  has_one :past_trips, -> { past_trips }, class_name: 'Trip'


  def has_today_activities?
    current_trip.trip_activities.today_activities.any?
  end

  def has_tomorrow_activities?
    current_trip.trip_activities.tomorrow_activities.any?
  end
end
