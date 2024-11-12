class CreateReportMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :report_mentions do |t|
      t.references :mentioning_report, null: false, foreign_key: true
      t.references :mentioned_report, null: false, foreign_key: true

      t.timestamps
    end
  end
end
