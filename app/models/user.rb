class User < ApplicationRecord
  def self.setup_by_saml_response(response)
    find_or_initialize_by(nameid: response.nameid).tap do |user|
      user.first_name = response.attributes[:first_name]
      user.last_name = response.attributes[:last_name]
      user.tel = response.attributes[:tel]
      user.save!
    end
  end
end
