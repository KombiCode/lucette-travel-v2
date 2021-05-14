class AddApiRefToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :api_provider, :string
    add_column :activities, :api_poi, :string
  end
end
