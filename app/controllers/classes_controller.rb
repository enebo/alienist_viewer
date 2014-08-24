class ClassesController < ApplicationController
  def index
    @classes = Memory.instance.classes
  end

  def show
    @class = Memory.instance.find_by_id params[:id].to_i
  end
end
