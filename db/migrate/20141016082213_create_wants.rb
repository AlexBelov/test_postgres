class CreateWants < ActiveRecord::Migration
  def change
    create_table :wants do |t|
      t.string :name
      t.references :alert
      t.datetime "deleted_at"
    end
    50.times { |t| Alert.create(name: "alert#{t}") }
  end
end
