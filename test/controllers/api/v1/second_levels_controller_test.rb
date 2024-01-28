require "controllers/api/v1/test"

class Api::V1::SecondLevelsControllerTest < Api::Test
def setup
  # See `test/controllers/api/test.rb` for common set up for API tests.
  super

  @first_level = create(:first_level, team: @team)
  @second_level = build(:second_level, first_level: @first_level)
  @other_second_levels = create_list(:second_level, 3)

  @another_second_level = create(:second_level, first_level: @first_level)

  # 🚅 super scaffolding will insert file-related logic above this line.
  @second_level.save
  @another_second_level.save

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
def assert_proper_object_serialization(second_level_data)
  # Fetch the second_level in question and prepare to compare it's attributes.
  second_level = SecondLevel.find(second_level_data["id"])

  assert_equal_or_nil second_level_data['data'], second_level.data
  # 🚅 super scaffolding will insert new fields above this line.

  assert_equal second_level_data["first_level_id"], second_level.first_level_id
end

test "index" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/first_levels/#{@first_level.id}/second_levels", params: {access_token: access_token}
  assert_response :success

  # Make sure it's returning our resources.
  second_level_ids_returned = response.parsed_body.map { |second_level| second_level["id"] }
  assert_includes(second_level_ids_returned, @second_level.id)

  # But not returning other people's resources.
  assert_not_includes(second_level_ids_returned, @other_second_levels[0].id)

  # And that the object structure is correct.
  assert_proper_object_serialization response.parsed_body.first
end

test "show" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/second_levels/#{@second_level.id}", params: {access_token: access_token}
  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  get "/api/v1/second_levels/#{@second_level.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "create" do
  # Use the serializer to generate a payload, but strip some attributes out.
  params = {access_token: access_token}
  second_level_data = JSON.parse(build(:second_level, first_level: nil).api_attributes.to_json)
  second_level_data.except!("id", "first_level_id", "created_at", "updated_at")
  params[:second_level] = second_level_data

  post "/api/v1/first_levels/#{@first_level.id}/second_levels", params: params
  assert_response :success

  # # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  post "/api/v1/first_levels/#{@first_level.id}/second_levels",
    params: params.merge({access_token: another_access_token})
  assert_response :not_found
end

test "update" do
  # Post an attribute update ensure nothing is seriously broken.
  put "/api/v1/second_levels/#{@second_level.id}", params: {
    access_token: access_token,
    second_level: {
      data: 'Alternative String Value',
      # 🚅 super scaffolding will also insert new fields above this line.
    }
  }

  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # But we have to manually assert the value was properly updated.
  @second_level.reload
  assert_equal @second_level.data, 'Alternative String Value'
  # 🚅 super scaffolding will additionally insert new fields above this line.

  # Also ensure we can't do that same action as another user.
  put "/api/v1/second_levels/#{@second_level.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "destroy" do
  # Delete and ensure it actually went away.
  assert_difference("SecondLevel.count", -1) do
    delete "/api/v1/second_levels/#{@second_level.id}", params: {access_token: access_token}
    assert_response :success
  end

  # Also ensure we can't do that same action as another user.
  delete "/api/v1/second_levels/#{@another_second_level.id}", params: {access_token: another_access_token}
  assert_response :not_found
end
end
