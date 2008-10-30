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
  # abstract implementation of cache container
  class CacheContainer

    @@m_memcache_server_client = nil

    def self.version
      return "$LastChangedRevision$"
    end

    def self.setup(p_arguments)
      puts "Setting up memcached server."

      # find server configuration
      namespace = p_arguments["namespace"]
      servers = []
      server_configurations = p_arguments["servers"]
      servers = server_configurations.values

      # startup server connection
      @@m_memcache_server_client = MemCache.new(servers, :namespace => namespace)

      return true
    end

    def self.close
      puts "Closing memcached server"
    end

    def self.cache(p_key, p_object, p_options = {})
      puts "Adding cache for - #{p_key} of type #{p_object.class} options #{p_options}"
      begin
        expiry = 0
        raw = false
        if (!p_options.nil? && !p_options.empty?)
          expiry = p_options.delete(:expiry) || 0
          raw = p_options.delete(:raw) || false
        end
        puts "Expire after - #{expiry}"
        return @@m_memcache_server_client.set(p_key, p_object, expiry)
      rescue
        puts "Reconnect server."
        self.setup()
      end
    end

    def self.get(p_key, p_options = {})
      puts "Pick cache of key - #{p_key}"
      begin
        raw = false
        if (!p_options.nil? && !p_options.empty? && !p_options[:raw].nil?)
          raw = p_options[:raw]
        end
        return @@m_memcache_server_client[p_key]
      rescue
        puts "Reconnect server."
        self.setup()
      end
    end

    def self.destroy(p_key, p_options = {})
      puts "Destroy cache for - #{p_key}"
      expiry = 0
      raw = false
      if (!p_options.nil? && !p_options.empty?)
        expiry = p_options.delete(:expiry) || 0
        raw = p_options.delete(:raw) || false
      end
      @@m_memcache_server_client.delete(p_key, expiry, raw)
    end

    def self.stats
      return @@m_memcache_server_client.stats
    end
  end
end