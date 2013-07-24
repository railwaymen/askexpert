class Mailer < ActionMailer::Base
  default from: "from@example.com"

  def share(email, shared_message)
    @share = shared_message

    mail to: email, subject: "AskExpert post"
  end
end
