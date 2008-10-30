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
require 'socket'

# TODO: replace this implementation with memdcached library
module Cache
  # abstract implementation of cache container
  class CacheContainer

    @@m_memcache_server_client = []
    @@m_configurations = nil

    def self.version
      return "$LastChangedRevision$"
    end

    def self.setup(p_arguments)
      @@m_configurations = p_arguments
      servers = @@m_configurations["servers"].values
      servers.each do |server|
        parts = server.split(":")
        host = parts.first
        port = parts.last.to_i
        @@m_memcache_server_client << TCPSocket.new(host, port)
      end
      return true
    end

    def self.close
      @@m_memcache_server_client.each do |server|
        server.close
      end
    end

    def self.cache(p_key, p_object, p_options = {})
    end

    def self.get(p_key, p_options = {})
    end

    def self.destroy(p_key, p_options = {})
      send_command("delete #{p_key}\n", "(DELETED|NOT_FOUND)") do |response_line|
      end
      return true
    end

    def self.flush_all(p_optioins = {})
      send_command("flush_all\n", "OK") do |line|
      end
      return true
    end

    def self.stats(p_options = {})
      stats_map = {}
      send_command("stats\n") do |response_line|
        parts = response_line.split("\s")
        stats_map[parts[1]] = parts.last 
      end
      return stats_map
    end

    # TODO: improve this method, it has many chance to throw the exception
    # TODO: now only support single server request
    def self.send_command(p_command, p_ending_line = "end")
      begin
        process_command(p_command, p_ending_line)
      rescue
        setup(@@m_configurations)
        process_command(p_command, p_ending_line)
      end
    end
    
    def self.process_command(p_command, p_ending_line)
      @@m_memcache_server_client.first.puts(p_command)
      while (line = @@m_memcache_server_client.first.readline)
        if line.downcase.match(/^#{p_ending_line}/i)
          break
        else
          yield(line)
        end
      end
    end
  end
end