require "shopifly/version"
require "thor"
require "faraday"
require "json"

module Shopifly
  class CLI < Thor
    desc "branch NAME", "creates new git branch"\
    " and names a copy of your Shopify master theme"

    def branch(name)
      # `git checkout -b #{name}`
      # puts "#{name} is your new branch"

      #Define these elsewhere
      username = ""
      password = ""
      shop = ''
      api_version = ''

      #Make Faraday object with url and authentication
      conn = Faraday.new(url: "https://#{shop}.myshopify.com/")
      conn.basic_auth(username, password)

      #Get request for shopify themes
      themes_response = conn.get("admin/api/#{api_version}/themes.json") 

      #Check if response was successful
      if themes_response.status != 200 then
        puts "Shopify connection failure. "\
         "Response Status: #{themes_response.status}"
        return
      end 
      
      #Parse response and find main theme
      themes_json = JSON.parse themes_response.body
      themes_array = themes_json["themes"]
      main_theme = themes_array.select do |theme| 
        theme["role"] == "main"
      end
      main_theme_hash = main_theme[0]
      puts main_theme_hash

      #Get asset keys for all assets in theme
      assets_response = conn.get("admin/api/#{api_version}"\
      "/themes/#{main_theme_hash["id"]}/assets.json")
      assets_json = JSON.parse assets_response.body
      assets_array = assets_json["assets"];
      asset_keys = []
      assets_array.each do |asset|
        asset_keys << asset["key"]
      end

      puts asset_keys

    end

    private

    def get_themes_from_shopify(username:, password:,
      shop:, api_version:, resource:)
    end
  end

  class Error < StandardError; end
  # Your code goes here...
end
