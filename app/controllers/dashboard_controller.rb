class DashboardController < ApplicationController
  layout "template-1"

  def index
    @tab = params[:tab]

    # handle selected tab
    case @tab
    when "information"
      handle_information_tab
    end
  end

  def delete_cache
    cache_key = params[:cache_key]
    if cache_key
      destroy_cache(cache_key)
      flash[:notice] = "we have successfully removed your ca$h ##{cache_key}"
    else
      flash[:notice] = "maan!!, don't you see the point why we didn't remove this ca$h?"
    end
    redirect_to :back
  end

  def cache_flush_all
    if flush_all
      flash[:notice] = "you have successfully flushed your toilet."
    else
      flash[:notice] = "what was in your toilet?"
    end
    redirect_to :back
  end

  private
    def handle_information_tab
      @statistic = Statistics.find(:first, :order => "id DESC")  
    end
end
