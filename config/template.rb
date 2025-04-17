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
    
    guard :shell do
      watch %r{^app/views/(.+).html.erb$} do |m|
        `bundle exec htmlbeautifier #{m[0]}`
      end
      watch %r{^app/components/(.+).html.erb$} do |m|
        `bundle exec htmlbeautifier #{m[0]}`
        `bundle exec erb_lint --autocorrect #{m[0]}`
      end
      watch %r{^config/locales/(.+).yml$} do |m|
        `bundle exec yaml-sort -l -i "#{m[0]}"`
      end
      watch %r{^app/(.+).yml$} do |m|
        `bundle exec yaml-sort -l -i "#{m[0]}"`
      end
      watch "config/icons.yml" do
        `bundle exec yaml-sort -l -i "config/icons.yml"`
      end
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
  gem "guard-shell", require: false
  gem "ruby-lsp"
  gem "yaml-sort"
  gem "standard_procedure_fabrik"
end

gem_group :test do
  gem "rspec-openapi"
end

gsub_file "Gemfile", /# gem "bcrypt"/, "gem \"bcrypt\""
gsub_file "Gemfile", /# gem "image_processing".*/, "gem \"image_processing\""
gem "phlex-rails", ">= 2.0.0"
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
  rails_command "importmap:install"
  generate "rspec:install"
  generate "solid_cable:install"
  generate "solid_cache:install"
  generate "solid_queue:install"
  rails_command "turbo:install"
  rails_command "stimulus:install"
  rails_command "active_storage:install"
  rails_command "action_text:install"
  generate "phlex:install"
  generate "rswag:ui:install"
  gsub_file "config/initializers/rswag_ui.rb", /swagger_endpoint/, "openapi_endpoint"

  create_file "app/components/slotted.rb" do
    <<~PHLEX
        # frozen_string_literal: true

      class Components::Slotted < Components::Base
        def before_template(&)
          vanish(&)
          super
        end
      end
    PHLEX
  end

  create_file "app/components/layout.rb" do
    <<~PHLEX
      # frozen_string_literal: true
      
      class Components::Layout < Components::Slotted
        include Phlex::Rails::Helpers::CSRFMetaTags
        include Phlex::Rails::Helpers::CSPMetaTag
        include Phlex::Rails::Helpers::StylesheetLinkTag
        include Phlex::Rails::Helpers::JavascriptImportmapTags
      
        def initialize title: "Rails"
          @title = title.to_s
          @page_header = nil
          @page_footer = nil
        end
      
        def page_header(&contents) = @page_header = contents
      
        def page_footer(&contents) = @page_footer = contents
      
        def view_template(&)
          doctype   
          html do
            head do
              title { @title }
              meta name: "viewport", content: "width=device-width,initial-scale=1"
              meta name: "apple-mobile-web-app-capable", content: "yes"
              meta name: "mobile-web-app-capable", content: "yes"
              meta name: "view-transition", content: "same-origin"
              meta name: "turbo-refresh-method", content: "morph"
              meta name: "turbo-refresh-scroll", content: "preserve"
              csrf_meta_tags
              csp_meta_tag
              link rel: "manifest", href: pwa_manifest_path(format: :json)
              link rel: "icon", href: "/icon.png", type: "image/png"
              link rel: "icon", href: "/icon.svg", type: "image/svg+xml"
              link rel: "apple-touch-icon", href: "/icon.png"
              link rel: "stylesheet", href: "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
              stylesheet_link_tag :app, "data-turbo-track": "reload"
              javascript_importmap_tags
            end
      
            body do
              @page_header&.call
              main do
                yield if block_given?
              end
              @page_footer&.call
            end
          end
        end
      end
    PHLEX
  end
end
