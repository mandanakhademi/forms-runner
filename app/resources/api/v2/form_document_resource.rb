class Api::V2::FormDocumentResource < ActiveResource::Base
  self.element_name = "form"
  self.site = Settings.forms_api.base_url
  self.prefix = "/api/v2/"
  self.include_format_in_path = false

  # Include development API key for server-to-server requests when available
  if defined?(Settings) && Settings.respond_to?(:forms_api) && Settings.forms_api.respond_to?(:auth_key)
    headers['X-Forms-Api-Key'] = Settings.forms_api.auth_key if Settings.forms_api.auth_key.present?
  end

  has_many :steps, class_name: "Api::V2::StepResource"

  class << self
    def find(form_id, tag, params: {})
      super(:one, from: "#{prefix}#{collection_name}/#{form_id}/#{tag}", params:)
    end

    def get(form_id, tag, **options)
      super("#{form_id}/#{tag}", **options)
    end
  end
end
