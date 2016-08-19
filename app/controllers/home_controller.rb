class HomeController < ApplicationController
  def index
    session.delete(:dde_object) unless session[:dde_object].blank?

    @settings = YAML.load_file("#{Rails.root}/config/dde_connection.yml")[Rails.env] rescue {}

    if secure?
      url = "https://#{(@settings["dde_username"])}:#{(@settings["dde_password"])}@#{(@settings["dde_server"])}/retrieve_births"
    else
      url = "http://#{(@settings["dde_username"])}:#{(@settings["dde_password"])}@#{(@settings["dde_server"])}/retrieve_births"
    end

    birthdate = "19/Mar/2014".to_date
    @new_births = JSON.parse(RestClient.post(url, {"date" => birthdate}))

    render :layout => false
  end

  def show_new_births

  end
  
  def secure?
    @settings = YAML.load_file("#{Rails.root}/config/dde_connection.yml")[Rails.env]
    secure = @settings["secure_connection"] rescue false
  end
  
end
