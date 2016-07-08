class CollaboratorsController < ApplicationController
  before_action :set_wiki
  def index
    @users = User.all
  end

  def create
    @collaborator = @wiki.collaborators.new(user_id: params[:user_id])
    if @collaborator.save
      flash[:notice] = "Collaborator was saved successfully."
    else
      flash.now[:alert] = "There was an error saving the Collaborator. Please try again."
    end
    redirect_to :back
  end

  def destroy
    @collaborator = Collaborator.find(params[:id])
    if @collaborator.destroy
      flash[:notice] = "Collaborator was deleted successfully."
    else
      flash.now[:alert] = "There was an error deleting the Collaborator. Please try again."
    end
    redirect_to :back
  end

private
  def set_wiki
    @wiki = Wiki.find(params[:wiki_id])
  end
end
