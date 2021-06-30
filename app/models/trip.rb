class Trip < ApplicationRecord
  has_many :bookings
  has_many :trip_activities
  has_many :activities, through: :trip_activities
  has_many :tasks
  belongs_to :user

  scope :current_trip, -> { where("begin_date <= ?", Date.current).where("end_date >= ?", Date.current) }
  scope :next_trips, -> { where("begin_date > ?", Date.current).order(:begin_date) }
  scope :past_trips, -> { where("end_date < ?", Date.current).order(end_date: :desc) }

  def today_activities
    trip_activities.today_activities
  end

  def day_activities(day_date)
    trip_activities.day_activities(day_date).order(start_hour: :asc)
  end

  def number_of_days
    nd = (end_date - begin_date).to_i
  end

  def date_for_day(index)
    begin_date + index
  end

  def day_bookings(index)
    day_bookings = bookings.select { |b|
      (date_for_day(index) >= b.begin_date.to_date) &&
      (date_for_day(index) <= b.end_date.to_date)
    }
  end

  def index_for_today()
    it = 0
    if begin_date <= Date.current && end_date >= Date.current
      it = (Date.current - begin_date.to_date).to_i
    end
    it
  end
end
