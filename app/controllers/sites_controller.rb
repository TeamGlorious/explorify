class SitesController < ApplicationController
  def index
    @current_user = current_user
  end

  def about
    render "/sites/about"
  end
end
