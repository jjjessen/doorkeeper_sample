puts ("Destroying all old data on Development environment.")
SecondLevel.destroy_all
FirstLevel.destroy_all
Membership.destroy_all
application_ids = Doorkeeper::Application.all.pluck(:id)
User.all.where(platform_agent_of: application_ids).destroy_all
Doorkeeper::AccessToken.destroy_all
Doorkeeper::Application.destroy_all
Team.destroy_all
User.destroy_all


puts "🌱 Generating development environment seeds."



team= Team.create!(name:"Test Team", time_zone: "Copenhagen")
admin = User.create!(email:"admin@test.sphinx.dk",
                   first_name:"Test",
                   last_name:"Admin",
                   password: "123123password123123",
                   password_confirmation: "123123password123123",
                   sign_in_count: 1,
                   current_sign_in_at: Time.now,
                   last_sign_in_at: 1.day.ago,
                   current_sign_in_ip: "127.0.0.1",
                   last_sign_in_ip: "127.0.0.2",
                   time_zone: "Copenhagen")

non_admin = User.create!(email:"non_admin@test.sphinx.dk",
                              first_name:"Test",
                              last_name:"Non Admin",
                              password: "123123password123123",
                              password_confirmation: "123123password123123",
                              sign_in_count: 1,
                              current_sign_in_at: Time.now,
                              last_sign_in_at: 1.day.ago,
                              current_sign_in_ip: "127.0.0.1",
                              last_sign_in_ip: "127.0.0.2",
                              time_zone: "Copenhagen")

Membership.create!(user_id: admin.id,
                   team_id: team.id,
                   created_at: Time.now,
                   updated_at: Time.now,
                   user_first_name: admin.first_name,
                   user_last_name: admin.last_name,
                   user_email: admin.email,
                   role_ids: ["admin"])


Membership.create!(user_id: non_admin.id,
                   team_id: team.id,
                   created_at: Time.now,
                   updated_at: Time.now,
                   user_first_name: non_admin.first_name,
                   user_last_name: non_admin.last_name,
                   user_email: non_admin.email,
                   role_ids: ["not_admin"])

fl= FirstLevel.create!(data:"FirstLevel data", team_id: team.id)
sl= SecondLevel.create!(data:"SecondLevel data", first_level_id: fl.id)

Doorkeeper::Application.create!(name: "AndroidPlatform", redirect_uri:"dk.sphinx://callback",uid:"2amPYEQOHVBN-Jc8tj4VC_gpUCi_oq0pM5oXScSmua1", scopes:"", confidential:false, team_id:nil)
Doorkeeper::Application.create!(name: "IOSPlatform", redirect_uri:"dk.sphinx://callback",uid:"2amPYEQOHVBN-Jc8tj4VC_gpUCi_oq0pM5oXScSmua2", scopes:"", confidential:false, team_id:nil)
Doorkeeper::Application.create!(name: "DummyTest", redirect_uri:"https://openidconnect.net/callback",uid:"2amPYEQOHVBN-Jc8tj4VC_gpUCi_oq0pM5oXScSmua3", scopes:"", confidential:false, team_id:nil)
