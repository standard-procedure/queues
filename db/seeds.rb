require_relative "fabrik"

Fabrik.db.users.create :alice, email_address: "alice@example.com", first_name: "Alice"
Fabrik.db.users.create :bob, email_address: "bob@example.com", first_name: "Bob"
Fabrik.db.users.create :claire, email_address: "claire@example.com", first_name: "Claire"
Fabrik.db.users.create :dave, email_address: "dave@example.com", first_name: "Dave"
Fabrik.db.users.create :ellie, email_address: "ellie@example.com", first_name: "Ellie"

Fabrik.db.projects.create :nwrug, name: "NWRUG website", owner: Fabrik.db.users.alice
Fabrik.db.projects.create :megacorp, name: "MegaCorp HR System", owner: Fabrik.db.users.bob
Fabrik.db.projects.create :medio, name: "Medio platform", owner: Fabrik.db.users.claire
