class SitesController < ApplicationController
  def index
    @current_user = current_user
  end

  def about
    render "/sites/about"
  end

  def contact
    render "/sites/contact"
  end
end
