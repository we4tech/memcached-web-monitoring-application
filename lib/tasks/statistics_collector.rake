# collect statistical data from the memcached server
require File.join(RAILS_ROOT, "lib/statistics_collection_helper")
namespace :statistics do

  desc "collect statistical data from memcached server"
  task :collector => :environment do
    StatisticsHelper::Collector::start_collecting
  end
end