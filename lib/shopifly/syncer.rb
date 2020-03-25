require "yaml"
require "shopify_api"
require "pry"

module Shopifly
  class Syncer
    def initialize
      @config = Shopifly::Config.new
      @store_config = @config.store_config
      @shared_config = @config.shared_config
    end

    def sync
      with_settings = ARGV.include? "--with-settings"

      themes_array = ShopifyAPI::Theme.find(:all)

      current_theme = themes_array.select do |theme|
        theme.attributes["name"] == @config.current_branch
      end.first

      if current_theme.nil?
        p "Theme doesn't exist, creating..."
        current_theme = create_theme(@config.current_branch)

        if current_theme.errors.present?
          return p "Errors: #{current_theme.errors.first}"
        end

        with_settings_json(current_theme, default_theme) do
          deploy_theme if set_config_for(current_theme, true)
        end
      else
        p "Theme already exists: #{@config.current_branch}, #{@config.store_url}"
        if with_settings
          with_settings_json(current_theme, default_theme) do
            set_config_for(current_theme, false)
          end
        else
          set_config_for(current_theme, false)
        end
      end
    end

    def deploy_theme
      p "Uploading theme!"
      system @config.deploy_command
    end

    def with_settings_json(current_theme, default_theme)
      yield

      set_config_for(default_theme, true)
      get_settings_json

      set_config_for(current_theme, true)
      upload_settings_json

      delete_settings_json
    end

    def default_theme
      @default_theme ||= begin
        themes_array = ShopifyAPI::Theme.find(:all)

        themes_array.select do |theme|
          theme.attributes["role"] == "main"
        end.first
      end
    end

    def get_settings_json
      p "Downloading settings"

      system("theme download config/settings_data.json")
    end

    def delete_settings_json
      p "Removing local settings"

      `rm #{@shared_config["directory"]}config/settings_data.json`
    end

    def upload_settings_json
      p "Uploading settings"

      config = File.read("config.yml")

      if config.include? "theme_id: #{@default_theme.attributes['id']}"
        raise "Refusing to push settings_data.json to currently published branch"
      end

      system("theme deploy config/settings_data.json")
    end

    def create_theme(branch)
      ShopifyAPI::Theme.create(name: branch)
    end

    def set_config_for(theme, allow_config_override = false)
      p "Setting config to point to #{theme.attributes[:name]}, #{@config.store_url}"

      ignore_files = allow_config_override ? "[]" : @shared_config["ignore_files"]

      File.open("config.yml", "w") do |file|
        file.write <<~CONFIG
          build:
            password: #{@config.password}
            theme_name: "#{theme.attributes[:name]}"
            theme_id: #{theme.attributes[:id]}
            store: #{@config.store_url}
            directory: #{@shared_config['directory']}
            ignore_files: #{ignore_files}

          development:
            password: #{@config.password}
            theme_name: "#{theme.attributes[:name]}"
            theme_id: #{theme.attributes[:id]}
            store: #{@config.store_url}
            directory: #{@shared_config['directory']}
            ignore_files: #{ignore_files}

          production:
            password: #{@config.password}
            theme_name: "#{theme.attributes[:name]}"
            theme_id: #{theme.attributes[:id]}
            store: #{@config.store_url}
            directory: #{@shared_config['directory']}
            ignore_files: #{ignore_files}
        CONFIG
      end
    end
  end
end
