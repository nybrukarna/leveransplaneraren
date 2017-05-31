Leverans::App.helpers do
  def authorized?
    !session[:current_user].nil?
  end
end
