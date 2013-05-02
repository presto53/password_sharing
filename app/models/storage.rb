class Storage < ActiveRecord::Base
  attr_accessible :key, :password
  validates :password, :key, :presence => true
  validates_length_of :password, :maximum => 255
end
