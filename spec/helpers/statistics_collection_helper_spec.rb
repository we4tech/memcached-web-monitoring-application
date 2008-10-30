require File.dirname(__FILE__) + '/../spec_helper'
require File.join(RAILS_ROOT, "lib/statistics_collection_helper")

describe StatisticsHelper::Collector do

  describe "verify existing process" do
    before do
      @state, @lock_file = StatisticsHelper::Collector::running_existing_process?
      if File.exists?(@lock_file)
        File.delete(@lock_file)
        @state, @lock_file = StatisticsHelper::Collector::running_existing_process?
      end
    end

    it "should not find any running process" do
      @state.should eql(false)
      @lock_file.should_not be_nil 
    end

    it "should be able to save a new lock" do
      File.exists?(@lock_file).should eql(false)
      StatisticsHelper::Collector::lock(@lock_file).should eql(true)
      File.exists?(@lock_file).should eql(true)
    end
  end

  describe "without any existing process" do
    before do
      @state, @lock_file = StatisticsHelper::Collector::running_existing_process?
      if File.exists?(@lock_file)
        File.delete(@lock_file)
        @state, @lock_file = StatisticsHelper::Collector::running_existing_process?
      end
    end

    it "should create a lock file" do
    end

    it "should collect statistical data from memecached server" do
      StatisticsHelper::Collector::start_collecting
    end
  end

  describe "with an existing process" do
    it "should read existing lock" do

    end

    it "shouldn't run new process" do

    end
  end
end
