# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    @me = users(:me)
    @you = users(:you)
    @report = @me.reports.create(title: 'report_title', content: 'report_content')
    @mentioned_report1 = @me.reports.create(title: 'mentioned_report_title1', content: 'mentioned_report_content1')
    @mentioned_report2 = @me.reports.create(title: 'mentioned_report_title2', content: 'mentioned_report_content2')
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
    new_report = @me.reports.create(title: 'new_report_title', content: "http://localhost:3000/reports/#{@mentioned_report1.id}")
    assert_includes new_report.mentioning_reports, @mentioned_report1
  end

  test '日報を更新するとcontentに記載されたURLに対応するレポートがmentioning_reportsに追加される' do
    assert_not_includes @report.mentioning_reports, @mentioned_report1
    @report.update(content: "http://localhost:3000/reports/#{@mentioned_report1.id}")
    assert_includes @report.mentioning_reports, @mentioned_report1
  end

  test '日報を更新するとcontentに重複して記載されたURLは1回だけメンションとして追加される' do
    @report.update(content: "http://localhost:3000/reports/#{@mentioned_report1.id} http://localhost:3000/reports/#{@mentioned_report1.id}")
    assert_includes @report.mentioning_reports, @mentioned_report1
    assert_equal 1, @report.mentioning_reports.count
  end

  test '日報を更新するとcontentに重複せずに記載されたURLの数だけメンションとして追加される' do
    assert_not_includes @report.mentioning_reports, @mentioned_report1
    assert_not_includes @report.mentioning_reports, @mentioned_report2
    @report.update(content: "http://localhost:3000/reports/#{@mentioned_report1.id} http://localhost:3000/reports/#{@mentioned_report2.id}")
    assert_includes @report.mentioning_reports, @mentioned_report1
    assert_includes @report.mentioning_reports, @mentioned_report2
    assert_equal 2, @report.mentioning_reports.count
  end
end
