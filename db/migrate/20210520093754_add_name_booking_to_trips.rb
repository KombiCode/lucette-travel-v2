class AddNameBookingToTrips < ActiveRecord::Migration[6.0]
  def change
    add_column :trips, :name_booking, :string
  end
end
