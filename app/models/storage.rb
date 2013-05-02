class Storage < ActiveRecord::Base
  attr_accessible :key, :password
  validates :password, :key, :presence => true
  validates_length_of :password, :maximum => 255

  def self.remove_old
    # Remove passwords older than month
    Storage.where(:created_at < (Time.now-(60*60*24*30))).destroy_all
  end

end
