Leverans::App.controllers :admin do
  get :label, with: :week do
    week = params[:week]
    sheet = Leverans::Sheet.new(settings.google_sheet)
    unless sheet.users.weeks.include?(week)
      content_type :text
      response.write('Denna veckan finns inte!')
    else
      users = sheet.users.week(week)
      pdf = Leverans::Pdf::Labels.new(users, week)
      content_type :pdf
      attachment("labels_v#{week}.pdf")
      response.write(pdf.render)
    end
  end
end
