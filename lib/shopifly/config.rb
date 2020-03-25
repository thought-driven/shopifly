module Shopifly
  class Config
    attr_reader :current_branch, :shared_config, :store_url, :store_config, :deploy_command, :password

    def initialize
      file = File.read("config.stores.yml")
      config = YAML.safe_load(file)

      current_store = File.read(".current_store").strip
      @store_config = config["stores"][current_store]
      store = store_config["store"]

      @shared_config = config["shared_config"]
      @deploy_command = @shared_config["deploy_command"]
      @current_branch = `git branch | grep \\* | cut -d ' ' -f2`.strip
      @password = store_config["password"]
      @store_url = "#{store}.myshopify.com"

      api_key = store_config["api_key"]
      api_version = "2019-10"

      set_shopify_api(api_key, api_version, @password, @store_url)
    end

    def set_shopify_api(api_key, api_version, password, store_url)
      shop_url = "https://#{api_key}:#{password}@#{store_url}"
      ShopifyAPI::Base.api_version = api_version
      ShopifyAPI::Base.site = shop_url
    end

  end
end

