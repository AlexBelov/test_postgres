# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
100.times { |t| Alert.create(name: "alert#{t}") }
100.times { |t| Want.create(name: "want#{t}", alert_id: Alert.first(:offset => rand(Alert.count)).id) }
50.times { |t| Alert.first(:offset => rand(Alert.count)).destroy }
