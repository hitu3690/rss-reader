class Api::V1::HelloController < ApplicationController
  def index
    render json: {
      msg: "HEllo"
    }
  end
end
