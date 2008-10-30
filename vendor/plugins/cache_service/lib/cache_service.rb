# $Id$
# *****************************************************************************
# Copyright (C) 2005 - 2007 somewhere in .Net ltd.
# All Rights Reserved.  No use, copying or distribution of this
# work may be made except in accordance with a valid license
# agreement from somewhere in .Net LTD.  This notice must be included on
# all copies, modifications and derivatives of this work.
# *****************************************************************************
# $LastChangedBy$
# $LastChangedDate$
# $LastChangedRevision$
# *****************************************************************************
module Cache

  # configuration discovery
  class Configuration
    def self.discover
      configuration_file = "#{RAILS_ROOT}/config/cache-config.yml"
      puts "Loading configuration file from - #{configuration_file}"
      yaml = YAML.load_file(configuration_file)
      if yaml
        environment = ENV['RAILS_ENV']
        configuration = yaml[environment]
        if configuration
          puts "Loading cache service configuration."
          container = configuration.delete("container")

          # load cache container implementation
          require File.join(File.dirname(__FILE__), "/container/#{container}.rb")
          puts "Implemented cache container version - #{CacheContainer.version}"

          # start cache container service
          if CacheContainer.setup(configuration)
            puts "Cache container has been initiated."
          else
            raise "Cache container failed to initiate."
          end
        else
          puts "No cache service configuration found. you should have #{configuration_file} file."
        end
      end
    end
  end

  # abstract cache container
  class CacheContainer
    def self.version; raise "Not implemented"; end
    def self.setup(p_args); raise "Not implemented"; end
    def self.close; raise "Not implemented"; end
    def self.cache(p_key, p_object, p_options = {}); raise "Not implemented"; end
    def self.destroy(p_key, p_options = {}); raise "Not implemented"; end
    def self.get(p_key, p_options = {}); raise "Not implemented"; end
    def self.stats(p_options = {}); raise "Not implemented"; end
    def self.flush_all(p_options = {}); raise "Not implemented"; end
  end

  # injectable methods, which are used to delegate methods from +CacheContainer+
  module ClassMethods

    # add new content to cache, the cache key must be unique and intentional
    def add_to_cache(p_key, p_object, p_options = {})
      return CacheContainer.cache(p_key, p_object, p_options)
    end

    # pick item from cache
    def get_from_cache(p_key, p_options = {})
      cached_content = CacheContainer.get(p_key, p_options)
      return cached_content
    end

    # destroy cached content from cache container.
    def destroy_cache(p_key, p_options = {})
      return CacheContainer.destroy(p_key, p_options)
    end

    # collect stats
    def server_stats(p_options = {})
      return CacheContainer.stats(p_options)
    end

    # flush all caches
    def flush_all(p_options = {})
      return CacheContainer.flush_all(p_options)
    end
  end
end