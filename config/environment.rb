# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
PassSharing::Application.initialize!

# Set ActionMailer params
ActionMailer::Base.delivery_method = :sendmail
ActionMailer::Base.raise_delivery_errors = :true
ActionMailer::Base.perform_deliveries = :true
ActionMailer::Base.sendmail_settings = {:arguments => "-i"}
