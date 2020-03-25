require "thor"

module Shopifly
  class CLI < Thor
    using Rainbow

    desc "sync", "synchronize current git branch with shopify theme\n\n" \
      "this command looks for a shopify theme with the current branch name\n" \
      "if it finds such a theme, it sets your local config.yml to use it.\n" \
      "if it does not find such a theme, it creates a theme and then sets " \
      "your local config.yml to use it.\n" \
      "--with-settings: Force upload settings.json file from currently " \
      "published theme to currently configured theme\n"

    method_option "with-settings", type: :boolean, default: false
    def sync
      unless File.exist? "config.stores.yml"
        puts "file not found: config.stores.yml".red
        return
      end

      unless File.exist? ".current_store"
        puts "file not found: .current_store".red
        return
      end

      Shopifly::Syncer.new.sync
    end

    desc "open", "open the current theme in the browser"
    def open
      `theme open`
    end

    desc "themes", "open the themes view for the current store"
    def themes
      config = Shopifly::Config.new
      site = config.store_url
      `open "https://#{site}/admin/themes"`
    end

    desc "apps", "open the apps view for the current store"
    def apps
      config = Shopifly::Config.new
      site = config.store_url
      `open "https://#{site}/admin/apps"`
    end

    desc "init", "initialize with defaults"
    def init
      unless system "theme version"
        puts "Error: 'theme' command not found path. See " \
              "https://shopify.github.io/themekit/".red
        return
      end

      command = ask(
        "Command you use to deploy theme code to Shopify:",
        default: "theme deploy"
      )

      puts
      puts "Writing " + "sample.config.stores.yml".green

      write_sample_config(command)

      puts "Done."
      puts

      puts "Writing " + ".current_store".green

      write_current_store

      puts "Done."
      puts

      puts "To complete setup, configure " + "sample.config.stores.yml".green +
           " and rename to " + "config.stores.yml".green
      puts

      puts "Change the store that you sync to by editing " +
           ".current_store".green
      puts
    end

    private

    def write_current_store
      File.open(".current_store", "w") do |file|
        file.write <<~CONFIG
          development
        CONFIG
      end
    end

    def write_sample_config(command)
      File.open("sample.config.stores.yml", "w") do |file|
        file.write <<~CONFIG
          defaults:
            branch: "master"

          shared_config:
            deploy_command: "#{command}"
            directory: "shopify/"
            ignore_files:
              - "config/settings_data.json"

          stores:
            development:
              api_key: ""
              password: ""
              store: "my-site-dev"
            qa:
              api_key: ""
              password: ""
              store: "my-site-staging"
            production:
              api_key: ""
              password: ""
              store: "my-site-production"
        CONFIG
      end

    end
  end
end

