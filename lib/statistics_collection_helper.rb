# collect statistical data
module StatisticsHelper
  class Collector

    @@LOGGER = Logger.new(STDERR)
    class << self

      def start_collecting
        # if any process is already collecting data
        locked, lock_file = running_existing_process?
        if locked
          @@LOGGER.info("since an existing process is still working, we don't need to continue this new process.")
          return false

        # otherwise create an infinit loop
        else
          @@LOGGER.info("initiating infinit loop to collect data from memcached server")
          while(true)
            # create lock file or
            # update timestamp for the existing lock file
            lock(lock_file)
            # connect to memcached server
            # request for stat
            stats_map = server_stats

            # create statistical log
            Statistics.create(stats_map)

            # sleep for 5 minutues
            sleep(5.minutes.to_i)
            # update lock file status through updating the timestamp
          end
        end
      end

      # save new or update existing lock file with the current timestamp
      def lock(p_lock_file)
        lock_file = File.open(p_lock_file, "w")
        lock_file.write(Time.now.to_i.to_s)
        lock_file.close
        return true
      end

      # verify whether any other process is already running
      def running_existing_process?
        @@LOGGER.info("verifying whether any existing process is running.")
        lock_file_dir = File.join(RAILS_ROOT, "tmp/locks")

        # create lock file directory if not exists
        if !File.exists?(lock_file_dir)
          @@LOGGER.info("creating new lock directory.")
          Dir.mkdir(lock_file_dir)
        end

        # find lock file
        lock_file = File.join(lock_file_dir, "statistics.collector.lck")
        if File.exists?(lock_file)
          @@LOGGER.info("lock file exists - #{lock_file}")

          # read lock file data
          lock_file_resource = File.open(lock_file)
          lock_timestamp = Time.at(lock_file_resource.read.to_i)
          lock_file_resource.close
          @@LOGGER.info("lock file timestamp - #{lock_timestamp}")

          # if lock is last updated 5 minutes back
          not_changed_five_minutes_before = (Time.now - 5.minutes) > lock_timestamp
          if not_changed_five_minutes_before
            @@LOGGER.info("lock file is old")
            File.delete(lock_file)
            return false, lock_file
          else
            @@LOGGER.info("process is still alive and working.")
            return true, lock_file
          end
        else
          @@LOGGER.info("no lock file exists")
          return false, lock_file
        end
      end
    end
  end
end