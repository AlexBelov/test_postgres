class Alert < ActiveRecord::Base
  attr_accessible :name, :deleted_at
  has_many :wants
  acts_as_paranoid
end
