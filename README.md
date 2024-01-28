# Start
chmod 755 bin/docker-entrypoint-web
docker-compose up --build

In another terminal:
docker compose exec web rails db:create
docker compose exec web rails db:schema:load
docker compose exec web rails db:seed

The seed files generates a user with admin role and a user with non-admin role
Setup OAuth2 Applications. The db:seed step always deletes old data.




# Using
localhost:3000 for the app with seeded users:
admin@test.sphinx.dk
non_admin@test_sphix.dk
both has password: 123123password123123

Two data models under Team has been created:
FirstLevel
SecondLevel

Admin can manage FiratLevel and SecondLevel
Non-admin can only read FirstLevel and has no access to SecondLevel


# What has been done
docker compose exec web rails generate doorkeeper:pkce
docker compose exec web rails generate super_scaffold FirstLevel Team data:text_field 
docker compose exec web rails generate super_scaffold SecondLevel FirstLevel,Team data:text_field  

Development seed data created
Adde non-admin role to roles file

# How to interact with the app
docker compose exec web rails xxxx
where xxxx is a rails command
As an example:  docker compose exec web rails console
``` 
