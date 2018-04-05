class SamlController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:acs]

  def sso
    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  def acs
    response          = OneLogin::RubySaml::Response.new(params[:SAMLResponse], settings: saml_settings)
    response.settings = saml_settings

    if response.is_valid?
      user = User.setup_by_saml_response(response)
      sign_in(user)
      redirect_to root_path, notice: 'ログインしました'
    else
      Rails.logger.warn response.errors
      redirect_to root_path, alert: 'SSOでエラーが発生しました'
    end
  end

  def metadata
    meta = OneLogin::RubySaml::Metadata.new
    render xml: meta.generate(saml_settings), content_type: "application/samlmetadata+xml"
  end

  private

  def saml_settings
    OneLogin::RubySaml::Settings.new.tap do |settings|
      settings.assertion_consumer_service_url = ENV['SP_ACS_URL']
      settings.issuer                         = ENV['SP_ISSUER']
      settings.idp_entity_id                  = ENV['IDP_ENTITY_ID']
      settings.idp_sso_target_url             = ENV['IDP_SSO_TARGET_URL']
      settings.idp_cert                       = ENV['IDP_CERT']
      settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
    end
  end
end
