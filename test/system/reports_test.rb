# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @create_report = reports(:create_report)
    @update_report = reports(:update_report)
    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'インデックスに移動' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'レポートを作成' do
    visit reports_url
    click_link '日報の新規作成'

    fill_in 'タイトル', with: @create_report.title
    fill_in '内容', with: @create_report.content
    click_on '登録する'

    assert_selector 'h1', text: '日報の詳細'
    assert_text @create_report.title
    assert_text @create_report.content
    assert_text '日報が作成されました。'
    click_on '日報の一覧に戻る'
  end

  test 'レポートを更新' do
    visit report_url(@create_report)
    click_link 'この日報を編集'

    fill_in 'タイトル', with: @update_report.title
    fill_in '内容', with: @update_report.content
    click_on '更新する'

    assert_selector 'h1', text: '日報の詳細'
    assert_text @update_report.title
    assert_text @update_report.content
    assert_text '日報が更新されました。'
    click_on '日報の一覧に戻る'
  end

  test 'レポートを削除' do
    visit report_url(@update_report)
    click_on 'この日報を削除'

    assert_selector 'h1', text: '日報の一覧'
    assert_text '日報が削除されました。'
  end
end
