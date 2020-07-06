class StaticPagesController < ApplicationController
  def home
    render file: "public/home.html"
    # redirect_to "/home.html"
  end
end
