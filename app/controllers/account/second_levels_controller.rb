class Account::SecondLevelsController < Account::ApplicationController
  account_load_and_authorize_resource :second_level, through: :first_level, through_association: :second_levels

  # GET /account/first_levels/:first_level_id/second_levels
  # GET /account/first_levels/:first_level_id/second_levels.json
  def index
    delegate_json_to_api
  end

  # GET /account/second_levels/:id
  # GET /account/second_levels/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/first_levels/:first_level_id/second_levels/new
  def new
  end

  # GET /account/second_levels/:id/edit
  def edit
  end

  # POST /account/first_levels/:first_level_id/second_levels
  # POST /account/first_levels/:first_level_id/second_levels.json
  def create
    respond_to do |format|
      if @second_level.save
        format.html { redirect_to [:account, @second_level], notice: I18n.t("second_levels.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @second_level] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @second_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/second_levels/:id
  # PATCH/PUT /account/second_levels/:id.json
  def update
    respond_to do |format|
      if @second_level.update(second_level_params)
        format.html { redirect_to [:account, @second_level], notice: I18n.t("second_levels.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @second_level] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @second_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/second_levels/:id
  # DELETE /account/second_levels/:id.json
  def destroy
    @second_level.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @first_level, :second_levels], notice: I18n.t("second_levels.notifications.destroyed") }
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
