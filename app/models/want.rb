class Want < ActiveRecord::Base
  attr_accessible :name, :alert_id
  belongs_to :alert
end
