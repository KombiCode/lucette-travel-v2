class AddApiAttributionsToActivities < ActiveRecord::Migration[6.0]
  def change
      add_column :activities, :api_attributions, :json, using: 'api_attributions::JSON'
  end
end
