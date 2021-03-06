class ProjectsController < ApplicationController
  def show
    @project = Project.find_by_name(params[:project_name])
    render :text => 'Unknown project', :status => :not_found if @project.nil?
    respond_to do |format|
      format.html {}
      format.png { send_file File.join(Rails.public_path, "images/#{@project.last_complete_build_status}.png"), :disposition => 'inline', :content_type => Mime::Type.lookup_by_extension('png') }
    end
  end

  def force
    project = Project.find_by_name(params[:project_name])
    if project
      project.force_build
      redirect_to :back
    else
      render :text => 'Unknown project', :status => :not_found
    end
  end

  def index
    respond_to do |format|
      format.json { render :json => Project.all.to_json(:except => [:created_at, :modified_at], :methods => [:activity, :last_complete_build_status]) }
    end
  end
end
