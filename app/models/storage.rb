class Storage < ActiveRecord::Base
  attr_accessible :key, :password
  validates :password, :key, :presence => true
  validates_length_of :password, :maximum => 255

  def self.remove_old
    # Remove passwords older than month
    Storage.where(["created_at < ?", Time.now-30.days]).destroy_all
  end

end
