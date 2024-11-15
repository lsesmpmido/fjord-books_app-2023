# frozen_string_literal: true

require 'test_helper'

class ReportTest < Test::Unit::TestCase
  def setup
    @me = User.find_or_create_by(email: 'me@example.com') do |user|
      user.password = 'password'
    end
    @you = User.find_or_create_by(email: 'you@example.com') do |user|
      user.password = 'password'
    end
    @report = @me.reports.create(title: 'title', content: 'content')
    @mentioned_report = @me.reports.create(title: 'title', content: 'http://localhost:3000/reports/3')
  end

  sub_test_case '編集可能か判定' do
    test '日報の作成者ならtrueを返す' do
      assert_equal true, @report.editable?(@me)
    end

    test '日報の作成者でないならfalseを返す' do
      assert_equal false, @report.editable?(@you)
    end
  end

  sub_test_case '作成した日付を返す' do
    test '日報を今日作成したなら今日の日付を返す' do
      assert_equal Time.zone.today, @report.created_on
    end
  end

  sub_test_case 'メンションを保存' do
    test 'メンションを1つ付けて日報を新規作成すると1を返す' do
      assert_equal 1, @mentioned_report.mentioning_reports.ids.size
    end

    test 'メンションを2つ付けて日報を更新すると2を返す' do
      @mentioned_report.update(content: 'http://localhost:3000/reports/3 http://localhost:3000/reports/5')
      assert_equal 2, @mentioned_report.mentioning_reports.ids.size
    end
  end
end
