require File.dirname(__FILE__) + '/../spec_helper'

describe StatisticsController do
  fixtures :statistics

  describe "without previouse record id" do
    it "should render list of recent memory usages history" do
      get :logs
      assigns[:statistics].should_not be_nil
    end
  end
end
