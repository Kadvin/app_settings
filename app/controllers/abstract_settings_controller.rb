# 
# =Abstract Setting Management Controller
#
# You should inherit this controller to provide concret controller
#
class SettingsController < ApplicationController

  def index
    @settings = Setting.find_all_as_tree
  end

  def new
  end

  def create
    @setting = Setting.find_or_create_by_key(params[:setting]['key'])
    @setting.update_attributes(params[:setting])
    flash[:notice] = "The setting \"%s\" was created." % @setting.key
    redirect_to settings_url
  end

  def edit
    @setting = Setting.find(params[:id])
  end

  def update
    Setting.find(params[:id]).update_attribute(:value, params[:setting][:value])
    redirect_to settings_url
  end

  def destroy
    @setting = Setting.find(params[:id])
    @key = @setting.key
    @setting.destroy
    flash[:notice] = "The setting \"%s\" was deleted." % @key
    redirect_to settings_url
  end

end
