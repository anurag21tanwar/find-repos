class HomeController < ApplicationController
  def index
  end

  def search
    @repos = RepoSearchService.new(search_params[:username]).call
    render :index
  end

  private

  def search_params
    params.permit(:username)
  end
end
