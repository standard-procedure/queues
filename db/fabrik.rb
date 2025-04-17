Fabrik.db.configure do
  with User do
    unique :email
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email_address { |u| Faker::Internet.unique.email(name: u.first_name) }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
