desc "Populate Yesterday's Daily KPIs from the Replica"
task :daily_kpis_from_replica, [:date] => [:environment] do |t, args|
  puts "Adding KPIs for #{args[:date]} from Replica" if args[:date]
  date = args[:date] || Date.yesterday
  runner = KpiRunner.new(date)
  runner.run_kpis
  puts "KPIs Added from Replica."

  if Rails.env == 'production'
    runner.deliver_daily_report
    puts "Delivered Reports"
  end
end
