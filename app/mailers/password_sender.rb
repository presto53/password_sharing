class PasswordSender < ActionMailer::Base
  default from: APP_CONFIG['email_from']

  def send_email(mail)
    @url = mail[:url]
    @message = mail[:message]
    mail(:to => mail[:to],
         :subject => "Password")
  end
end
