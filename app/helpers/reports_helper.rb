module ReportsHelper
  def display_report(report)
    report.map{ |r| "<tr>" + r.map{|c| "<td>#{readable_number(c)}</td>"}.join + "</tr>"}.join
  end

  def readable_number(number)
    number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end
end
