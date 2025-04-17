Fabrik.db.configure do
  with User do
    unique :email_address
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email_address { |u| Faker::Internet.unique.email(name: u.first_name) }
    password { "password123" }
    password_confirmation { "password123" }
  end

  with Project do
    unique :name
    name { Faker::Marketing.unique.buzzwords }
    owner { users.create }
    status { "active" }
  end

  with Card do
    unique :project, :title
    title { Faker::Company.unique.bs }
    project { projects.create }
    status { "backlog" }
  end
end
