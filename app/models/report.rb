# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentioning_report_mentions, class_name: 'ReportMention', foreign_key: :mentioning_report_id, dependent: :destroy, inverse_of: :mentioning_report
  has_many :mentioning_reports, through: :mentioning_report_mentions, source: :mentioned_report
  has_many :mentioned_report_mentions, class_name: 'ReportMention', foreign_key: :mentioned_report_id, dependent: :destroy, inverse_of: :mentioned_report
  has_many :mentioned_reports, through: :mentioned_report_mentions, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def create_mentions_from_content
    urls = extract_urls_from_content(content)
    report_ids = urls.map { |url| url.match(%r{http://(?:localhost|127\.0\.0\.1):3000/reports/(\d+)})[1].to_i }.uniq
    reports = Report.where(id: report_ids).where.not(id:)
    self.mentioning_reports = reports
  end

  private

  def extract_urls_from_content(content)
    URI.extract(content, %w[http https])
  end
end
