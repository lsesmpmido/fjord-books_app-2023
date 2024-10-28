# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def after_sign_in_path_for(resource)
    books_path
  end
end
