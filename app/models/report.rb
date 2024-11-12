# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :report_mentions
  has_many :mentioning_reports, through: :report_mentions, source: :mentioned_report
  has_many :mentioned_reports, through: :report_mentions, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  # 本文に含まれるURLを解析して言及関係を作成
  def create_mentions_from_content
    # 本文からURLを抜き出す (例: 正規表現でリンクを抜き出す)
    urls = extract_urls_from_content(self.content)
    urls.each do |url|
      num = url.match(/(\d+)$/)
      puts "------------"
      puts num
      puts "------------"
      # URLから関連するReportを探す
      mentioned_report = Report.find_by(id: num)
      puts "------------"
      puts Report.find_by(id: num)
      puts "------------"
      next unless mentioned_report

      # 日報に言及元を追加
      self.mentioned_reports << Report.find_by(id: num) unless self.Report.find_by(id: num).include?(Report.find_by(id: num))
      # 日報に言及先を追加
      mentioned_report.mentioning_reports << self unless Report.find_by(id: num).Report.find_by(id: num).include?(self)
    end
  end

  private

  # 本文からURLを抽出する簡単な正規表現
  def extract_urls_from_content(content)
    URI.extract(content, ['http', 'https'])
  end
end
