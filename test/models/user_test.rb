# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: 'hoge@example.com')
  end

  test 'nameがnilならemailを返す' do
    @user.name = nil
    assert_equal 'hoge@example.com', @user.name_or_email
  end

  test 'nameが存在するならnameを返す' do
    @user.name = 'hoge'
    assert_equal 'hoge', @user.name_or_email
  end
end
