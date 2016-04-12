class EventsController < ApplicationController

  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def event_params
    parms.require(:event).permit(:user_id, :jb_event_id)
  end

end
