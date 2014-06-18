class QuestionMailer < ActionMailer::Base
  default from: FROM_EMAIL

  def question_email(email, question, options)
    @question = Question.find(question)
    @result = @question.perform(options)
    filename = "#{@question.name}_#{Time.now.strftime("%m_%d_%y")}.csv"
    answer = @result.to_csv_data.insert(0, "Question #{@question.id} - #{@question.name} - With Params #{options.to_s.gsub(",","")}\n\n")
    mail.attachments[filename] = {
      :mime_type => 'text/csv; charset=iso-8859-1; header=present',
      :content => answer
    }
    mail(
      :to => email,
      :subject => "Report for #{@question.name}"
    )
  end
end
