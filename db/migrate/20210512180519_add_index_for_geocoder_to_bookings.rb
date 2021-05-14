class AddIndexForGeocoderToBookings < ActiveRecord::Migration[6.0]
  def change
    add_index :bookings, [:latitude, :longitude]
  end
end
