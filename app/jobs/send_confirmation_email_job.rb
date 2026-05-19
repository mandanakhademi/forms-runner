class SendConfirmationEmailJob < ApplicationJob
  queue_as :confirmation_emails

  def perform(submission:, notify_response_id:, confirmation_email_address:)
    set_submission_logging_attributes(submission:)

    form = submission.form
    welsh_form = fetch_welsh_form(submission:, form:)
    mail = FormSubmissionConfirmationMailer.send_confirmation_email(
      form:,
      welsh_form:,
      submission:,
      notify_response_id:,
      confirmation_email_address:,
    )

    mail.deliver_now
    CurrentJobLoggingAttributes.confirmation_email_id = mail.govuk_notify_response.id
  rescue StandardError
    CloudWatchService.record_job_failure_metric(self.class.name)
    raise
  end

private

  def fetch_welsh_form(submission:, form:)
    return nil unless submission.submission_locale.to_sym == :cy

    form_document = Api::V2::FormDocumentRepository.find_with_mode(
      form_id: form.id,
      mode: submission.mode_object,
      language: :cy,
    )
    Form.new(form_document) if form_document
  end
end
