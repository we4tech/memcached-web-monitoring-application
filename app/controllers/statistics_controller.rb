class StatisticsController < ApplicationController

  layout false
  DEFAULT_ROW_LIMIT = 20

  # if no limit and previouse record id is not specified
  # retrieve recent 20 memory usages logs
  # if limit is specified
  # retrieve {limit} number of logs (user defined limit can't exceed 100 items)
  # if record id is defined
  # retrieve {user specified limit or 20} number of logs from the
  #   specified record id
  # ie. if record id is 100, then the request will retrieve logs which
  #   was stored after 100
  # select parameter must be defiend to retrieve the related contents
  def logs
    selectable_fields = params[:select]
    if selectable_fields
      selectable_fields = selectable_fields.gsub(/[\s'"]/, "")
      selectable_fields = selectable_fields.split(",")
    else
      selectable_fields = ["*"]
    end
    @statistics = Statistics.find(:all, build_conditions(selectable_fields))
    @statistics.reverse!
    render_response
  end

  private
    def build_conditions(p_selectable_fields)
      # find row limit
      row_limit = params[:limit] || DEFAULT_ROW_LIMIT
      row_limit = row_limit.to_i if row_limit
      row_limit = 100 if row_limit > 100
      conditions = {:select => p_selectable_fields.collect{|f| f.to_s}.join(", "), :order => "id DESC", :limit => row_limit}

      # find last id
      last_id = params[:last_id].to_i
      if last_id != 0
        conditions[:conditions] = ["id > ?", last_id]
      end
      return conditions
    end

    def render_response
      render :xml => @statistics.to_xml
    end

end
