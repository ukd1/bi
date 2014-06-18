class KpiMailer < ActionMailer::Base
  default from: FROM_EMAIL

  def kpi_tag_report(tag, date)
    @date = date
    @stats = Kpi.results_for_tag_and_date(tag, date)
    @tag = tag
    mail(
      :to      => 'kpi_email_address',
      :subject => "KPI Report for #{tag} #{date.to_s}"
    )
  end
end
