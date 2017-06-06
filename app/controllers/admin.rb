Leverans::App.controllers :admin do

  get :index do
    sheet = Leverans::Sheet.new(settings.google_sheet)
    weeks = sheet.weeks
    render 'admin/index', locals: { weeks: weeks }
  end

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
      #attachment("etiketter_v#{week}.pdf")
      response.write(pdf.render)
    end
  end

  get :packinglist, with: :week do
    week = params[:week]
    sheet = Leverans::Sheet.new(settings.google_sheet)
    unless sheet.users.weeks.include?(week)
      content_type :text
      response.write('Denna veckan finns inte!')
    else
      users = sheet.users.week(week)
      pdf = Leverans::Pdf::PackingList.new(users, week)
      content_type :pdf
      #attachment("packlista_v#{week}.pdf")
      response.write(pdf.render)
    end
  end
end
