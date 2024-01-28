require "controllers/api/v1/test"

class Api::V1::FirstLevelsControllerTest < Api::Test
def setup
  # See `test/controllers/api/test.rb` for common set up for API tests.
  super

  @first_level = build(:first_level, team: @team)
  @other_first_levels = create_list(:first_level, 3)

  @another_first_level = create(:first_level, team: @team)

  # 🚅 super scaffolding will insert file-related logic above this line.
  @first_level.save
  @another_first_level.save

  @original_hide_things = ENV["HIDE_THINGS"]
  ENV["HIDE_THINGS"] = "false"
  Rails.application.reload_routes!
end

def teardown
  super
  ENV["HIDE_THINGS"] = @original_hide_things
  Rails.application.reload_routes!
end

# This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
# data we were previously providing to users _will_ break the test suite.
def assert_proper_object_serialization(first_level_data)
  # Fetch the first_level in question and prepare to compare it's attributes.
  first_level = FirstLevel.find(first_level_data["id"])

  assert_equal_or_nil first_level_data['data'], first_level.data
  # 🚅 super scaffolding will insert new fields above this line.

  assert_equal first_level_data["team_id"], first_level.team_id
end

test "index" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/teams/#{@team.id}/first_levels", params: {access_token: access_token}
  assert_response :success

  # Make sure it's returning our resources.
  first_level_ids_returned = response.parsed_body.map { |first_level| first_level["id"] }
  assert_includes(first_level_ids_returned, @first_level.id)

  # But not returning other people's resources.
  assert_not_includes(first_level_ids_returned, @other_first_levels[0].id)

  # And that the object structure is correct.
  assert_proper_object_serialization response.parsed_body.first
end

test "show" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/first_levels/#{@first_level.id}", params: {access_token: access_token}
  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  get "/api/v1/first_levels/#{@first_level.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "create" do
  # Use the serializer to generate a payload, but strip some attributes out.
  params = {access_token: access_token}
  first_level_data = JSON.parse(build(:first_level, team: nil).api_attributes.to_json)
  first_level_data.except!("id", "team_id", "created_at", "updated_at")
  params[:first_level] = first_level_data

  post "/api/v1/teams/#{@team.id}/first_levels", params: params
  assert_response :success

  # # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  post "/api/v1/teams/#{@team.id}/first_levels",
    params: params.merge({access_token: another_access_token})
  assert_response :not_found
end

test "update" do
  # Post an attribute update ensure nothing is seriously broken.
  put "/api/v1/first_levels/#{@first_level.id}", params: {
    access_token: access_token,
    first_level: {
      data: 'Alternative String Value',
      # 🚅 super scaffolding will also insert new fields above this line.
    }
  }

  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # But we have to manually assert the value was properly updated.
  @first_level.reload
  assert_equal @first_level.data, 'Alternative String Value'
  # 🚅 super scaffolding will additionally insert new fields above this line.

  # Also ensure we can't do that same action as another user.
  put "/api/v1/first_levels/#{@first_level.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "destroy" do
  # Delete and ensure it actually went away.
  assert_difference("FirstLevel.count", -1) do
    delete "/api/v1/first_levels/#{@first_level.id}", params: {access_token: access_token}
    assert_response :success
  end

  # Also ensure we can't do that same action as another user.
  delete "/api/v1/first_levels/#{@another_first_level.id}", params: {access_token: another_access_token}
  assert_response :not_found
end
end
