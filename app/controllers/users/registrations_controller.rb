# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def after_sign_in_path_for(_resource)
    books_path
  end
end
