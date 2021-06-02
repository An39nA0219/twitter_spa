class User::TimelinesController < ApplicationController

  before_action :require_user_logged_in

  def index
    render json: "toppage"
  end
end
