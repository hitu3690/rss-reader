class StaticPagesController < ApplicationController
  def home
    render file: "public/login.html"
    # redirect_to "/home.html"
  end
end
