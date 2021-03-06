# frozen_string_literal: true

require "test_helper"

# Tests that mail views are rendered correctly, sent to correct user, and have a
# correct subject line.
class UserMailerTest < ActionMailer::TestCase
  test "reviewer digest email" do
    valid = users(:valid)
    mail = UserMailer.reviewer_digest(valid)
    assert_equal [valid.email], mail.to
    assert_equal "Reviewer digest for #{Time.zone.today.strftime("%a %d %b %Y")}", mail.subject
    assert_match(/Dear #{valid.username},/, mail.body.encoded)
  end

  test "daua approved email" do
    agreement = data_requests(:approved)
    admin = users(:admin)
    mail = UserMailer.daua_approved(agreement, admin)
    assert_equal [agreement.user.email], mail.to
    assert_equal "Your data request has been approved", mail.subject
    assert_match(/Your data request has been approved\./, mail.body.encoded)
  end

  test "daua sent back for resubmission email" do
    agreement = data_requests(:resubmit)
    admin = users(:admin)
    mail = UserMailer.sent_back_for_resubmission(agreement, admin)
    assert_equal [agreement.user.email], mail.to
    assert_equal "Please resubmit your data request", mail.subject
    assert_match(/Your data request is missing required information\./, mail.body.encoded)
  end

  test "mentioned during review of agreement email" do
    reviewer = users(:reviewer_two_on_released)
    agreement_event = agreement_events(:submitted_two_comment)
    mail = UserMailer.mentioned_in_agreement_comment(agreement_event, reviewer)
    assert_equal [reviewer.email], mail.to
    assert_equal "#{agreement_event.user.username} mentioned you on a data request", mail.subject
    assert_match(/#{agreement_event.user.username} mentioned you while reviewing a data request\./, mail.body.encoded)
  end
end
