# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::FirstLevelsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :first_level, through: :team, through_association: :first_levels

    # GET /api/v1/teams/:team_id/first_levels
    def index
    end

    # GET /api/v1/first_levels/:id
    def show
    end

    # POST /api/v1/teams/:team_id/first_levels
    def create
      if @first_level.save
        render :show, status: :created, location: [:api, :v1, @first_level]
      else
        render json: @first_level.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/first_levels/:id
    def update
      if @first_level.update(first_level_params)
        render :show
      else
        render json: @first_level.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/first_levels/:id
    def destroy
      @first_level.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def first_level_params
        strong_params = params.require(:first_level).permit(
          *permitted_fields,
          :data,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::FirstLevelsController
  end
end
