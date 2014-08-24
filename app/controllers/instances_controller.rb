class InstancesController < ApplicationController
  def show
    @instance = Memory.instance.find_by_id params[:id].to_i
  end
end
