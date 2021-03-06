# Baseline requirements for testing that may come from various sources
class RequirementsController < ApplicationController
  before_action :set_requirement, only: [:show, :update, :destroy, :execute]

  # GET /requirements
  def index
    @requirements = Requirement.all
    render json: @requirements
  end

  # GET /requirements/1
  def show
    render json: @requirement
  end

  # POST /requirements
  def create
    @requirement = Requirement.new(requirement_params)
    if @requirement.save
      render json: @requirement, status: :created, location: @requirement
    else
      render json: @requirement.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /requirements/1
  def update
    if @requirement.update(requirement_params)
      render json: @requirement
    else
      render json: @requirement.errors, status: :unprocessable_entity
    end
  end

  # DELETE /requirements/1
  def destroy
    @requirement.destroy
  end

  def execute
    @requirement_instance = RequirementInstance.create(requirement: @requirement)
    @requirement.validations.each do |v|
      ValidationInstance.create!(
        url: @url,
        validation: v,
        requirement_instance: @requirement_instance,
        state: 'running'
      )
    end
    RequirementWorker.perform_async(@requirement_instance._id)
    redirect_to @requirement_instance
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_requirement
    @requirement = Requirement.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def requirement_params
    params.fetch(:requirement, {})
  end
end
