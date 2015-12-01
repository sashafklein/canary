class ApplicationMailer < ActionMailer::Base
  default from: "<Canary Notifier notifier@app44227171@heroku.com>"
  layout 'mailer'
end
