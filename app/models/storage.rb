class Storage < ActiveRecord::Base
  attr_accessible :key, :password
  validates :password, :key, :presence => true
end
