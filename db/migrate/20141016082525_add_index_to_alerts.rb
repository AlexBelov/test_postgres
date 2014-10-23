class AddIndexToAlerts < ActiveRecord::Migration
  def change
    add_index :alerts, :name
  end
end
