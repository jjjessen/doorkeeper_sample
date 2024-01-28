class Account::FirstLevelsController < Account::ApplicationController
  account_load_and_authorize_resource :first_level, through: :team, through_association: :first_levels

  # GET /account/teams/:team_id/first_levels
  # GET /account/teams/:team_id/first_levels.json
  def index
    delegate_json_to_api
  end

  # GET /account/first_levels/:id
  # GET /account/first_levels/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/first_levels/new
  def new
  end

  # GET /account/first_levels/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/first_levels
  # POST /account/teams/:team_id/first_levels.json
  def create
    respond_to do |format|
      if @first_level.save
        format.html { redirect_to [:account, @first_level], notice: I18n.t("first_levels.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @first_level] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @first_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/first_levels/:id
  # PATCH/PUT /account/first_levels/:id.json
  def update
    respond_to do |format|
      if @first_level.update(first_level_params)
        format.html { redirect_to [:account, @first_level], notice: I18n.t("first_levels.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @first_level] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @first_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/first_levels/:id
  # DELETE /account/first_levels/:id.json
  def destroy
    @first_level.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :first_levels], notice: I18n.t("first_levels.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
