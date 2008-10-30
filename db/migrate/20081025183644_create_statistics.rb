class CreateStatistics < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.integer :pid
      t.integer :uptime
      t.integer :time
      t.integer :pointer_size
      t.float :rusage_user
      t.float :rusage_system
      t.integer :curr_items
      t.integer :total_items
      t.integer :bytes
      t.integer :curr_connections
      t.integer :total_connections
      t.integer :connection_structures
      t.integer :cmd_get
      t.integer :cmd_set
      t.integer :get_hits
      t.integer :get_misses
      t.integer :evictions
      t.integer :bytes_read
      t.integer :bytes_written
      t.integer :limit_maxbytes
      t.integer :threads
      t.string :version

      t.timestamps
    end
  end

  def self.down
    drop_table :statistics
  end
end
