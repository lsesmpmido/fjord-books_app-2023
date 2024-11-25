# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    @me = users(:me)
    @you = users(:you)
    @report = @me.reports.create(title: 'report_title', content: 'report_content')
    @mentioned_report = @me.reports.create(title: 'mentioned_report_title', content: 'mentioned_report_content')
  end

  test '日報の作成者ならeditable?(user)はtrueを返す' do
    assert_equal true, @report.editable?(@me)
  end

  test '日報の作成者でないならeditable?(user)はfalseを返す' do
    assert_equal false, @report.editable?(@you)
  end

  test '日報を今日作成したなら今日の日付を返す' do
    assert_equal Time.zone.today, @report.created_on
  end

  test '日報を作成するとcontentに記載されたURLに対応するレポートがmentioning_reportsに追加される' do
    new_report = @me.reports.create(title: 'new_report_title', content: "http://localhost:3000/reports/#{@mentioned_report.id}")
    assert_includes new_report.mentioning_reports, @mentioned_report
  end

  test '日報を更新するとcontentに記載されたURLに対応するレポートがmentioning_reportsに追加される' do
    assert_not_includes @report.mentioning_reports, @mentioned_report
    @report.update(content: "http://localhost:3000/reports/#{@mentioned_report.id}")
    assert_includes @report.mentioning_reports, @mentioned_report
  end

  test 'contentに記載された重複したURLは1回だけメンションとして追加される' do
    @report.update(content: "http://localhost:3000/reports/#{@mentioned_report.id} http://localhost:3000/reports/#{@mentioned_report.id}")
    assert_equal 1, @report.mentioning_reports.count
  end
end
