module Shopifly
  class CLI < Thor
    desc "sync", "synchronize current git branch with a remote shopify theme"
    def sync
      Shopifly::Syncer.new.sync
    end
  end
end

