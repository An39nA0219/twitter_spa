require "test_helper"

class NotificationMailerTest < ActionMailer::TestCase
  test "change_email" do
    mail = NotificationMailer.change_email
    assert_equal "Change email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
