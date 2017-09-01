class EventsController < ApplicationController
  before_action :require_login
  before_action :require_event_admin, only: [:index, :show, :edit, :update, :delete]
  # should only be visible to Admins
  # (should only show current admins events)
  def index
    @events = Event.all
  end

  # (should only show if logged in and current user is event admin
  def show
    @event = Event.find(params[:id])
  end
  #only if logged in
  def new
    @event = Event.new
  end
  # only if logged in
  def create
    @event = Event.new(event_params)
    @event.admin = current_admin
    if @event.save
      redirect_to @event
    else
      render 'new'
    end
  end
  # only if logged in and current user is event admin
  def edit
    @event = Event.find(params[:id])
  end
  # only if logged in and current user is event admin
  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to @event
    else
      render 'edit'
    end
  end
  # only if logged in and current user is event admin
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to events_path
  end

  private
    def event_params
      params.require(:event).permit(:name, :date_time, :location, :description)
    end

    def require_login
      unless logged_in?
        flash[:error] = "You must be logged in to access this section"
        redirect_to new_admin_session_path # halts request cycle
      end
    end

    def require_event_admin
      unless event.admin_id == current_user.id
        flash[:error] = "You must be event admin to access this section"
        redirect_to new_admin_session_path # halts request cycle
      end
    end
end
