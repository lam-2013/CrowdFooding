class EventsController < ApplicationController
  def index
    @events = []
    @search = Search.new(Event, params[:search])
    if is_search?
      @events = Event.search(@search, :page => params[:page])
    else
      @events = Event.paginate(:page => params[:page])
    end
  end
  private
  def is_search?
    @search.conditions
  end
end
