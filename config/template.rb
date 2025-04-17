# rails-new my_app --skip-thruster --skip-kamal --skip-jbuilder --skip-rubocop --devcontainer --javascript=bun --css=tailwind --database=WHATEVER
# Build the devcontainer, copy this file into config, then from within the container
# bin/rails app:template LOCATION=config/template.rb

inject_into_file ".devcontainer/devcontainer.json", after: "\"features\": {" do
  <<~CUSTOMISATIONS
    "ghcr.io/michidk/devcontainers-features/bun:1": {},
  CUSTOMISATIONS
end

inject_into_file ".devcontainer/devcontainer.json", after: "\"forwardPorts\": [3000]," do
  <<~CUSTOMISATIONS
    "customizations": {
      "vscode": {
        "extensions": [
          "Shopify.ruby-extensions-pack",
          "testdouble.vscode-standard-ruby",
          "manuelpuyol.erb-linter",
          "Shopify.ruby-lsp",
          "aki77.rails-db-schema",
          "miguel-savignano.ruby-symbols",
          "sibiraj-s.vscode-scss-formatter",
          "Thadeu.vscode-run-rspec-file",
          "Cronos87.yaml-symbols",
          "aliariff.vscode-erb-beautify"
        ]
      }
    },
  CUSTOMISATIONS
end

create_file "Guardfile" do
  <<~'GUARDFILE'
    group :development do
      guard :rspec, cmd: "bundle exec rspec" do
        watch(%r{^spec/.+_spec.rb$})
        watch(%r{^lib/(.+).rb$}) { "spec" }
        watch(%r{^app/(.+).rb$}) { |m| "spec/#{m[1]}_spec.rb" }
        watch(%r{^app/controllers/(.+).rb$}) { "spec" }
      end
    
      guard :bundler do
        require "guard/bundler"
        require "guard/bundler/verify"
        helper = Guard::Bundler::Verify.new
    
        files = ["Gemfile"]
        files += Dir["*.gemspec"] if files.any? { |f| helper.uses_gemspec?(f) }
    
        # Assume files are symlinked from somewhere
        files.each { |file| watch(helper.real_path(file)) }
      end
    end
    
    guard :standardrb, fix: true, all_on_start: true, progress: true do
      watch(/.+.rb$/)
    end
    
    guard "bundler_audit", run_on_start: true do
      watch("Gemfile.lock")
    end
  GUARDFILE
end

create_file "app.json" do
  <<~DOKKU
     {
      "name": "App",
      "description": "Rails app",
      "keywords": [],
      "scripts": {
        "dokku": {}
      },
      "healthchecks": {
        "web": [
          {
            "type": "startup",
            "name": "health check",
            "path": "/up",
            "attempts": 10,
            "initialDelay": 10,
            "timeout": 10
          }
        ]
      },
      "cron": []
    }
  DOKKU
end

gem_group :development, :test do
  gem "rspec-rails"
  gem "standard", ">= 1.4"
  gem "guard"
  gem "guard-bundler", require: false
  gem "guard-rspec", require: false
  gem "guard-standardrb", require: false
  gem "guard-bundler-audit", require: false
  gem "ruby-lsp"
  gem "yaml-sort"
  gem "standard_procedure_fabrik"
end

gem_group :test do
  gem "rspec-openapi"
end

gsub_file "Gemfile", /# gem "bcrypt"/, "gem \"bcrypt\""
gsub_file "Gemfile", /# gem "image_processing".*/, "gem \"image_processing\""
gem "faker"
gem "positioning"
gem "alba"
gem "kaminari"
gem "cancancan"
gem "rack-cors"
gem "rswag-ui"

initializer "alba.rb" do
  <<~ALBA
    Alba.backend = :active_support
    Alba.register_type :iso8601, converter: ->(time) { time.iso8601(3) }, auto_convert: true
  ALBA
end

after_bundle do
  rails_command "javascript:install:bun"
  generate "rspec:install"
  generate "solid_cable:install"
  generate "solid_cache:install"
  generate "solid_queue:install"
  rails_command "turbo:install"
  rails_command "stimulus:install"
  rails_command "active_storage:install"
  rails_command "action_text:install"
  generate "rswag:ui:install"
  gsub_file "config/initializers/rswag_ui.rb", /swagger_endpoint/, "openapi_endpoint"
end
