require "shopifly/version"
require "thor"

module Shopifly
  class CLI < Thor
    desc "branch NAME", "creates new git branch and and names a copy of your Shopify master theme"
    def branch(name)
      puts "#{name} is your new branch"
    end
  end
  class Error < StandardError; end
  # Your code goes here...
end
