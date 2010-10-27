class GraphTransactionGroup # < ActiveRecord::Base

  attr_accessor :trans

  def getData(key)
    @tg = TransactionGroup.find(key)
    @tg.transaction_group_items.all
    
    #@tg.each do | e |
    #  @data << Transhist.all :conditions => ["pm_context_value1 = ? AND pm_context_value2 = ? AND pm_context_value3 = ?", 
    #            e.pm_context_value1, e.pm_context_value2, e.pm_context_value3], :order => "collect_date ASC"
    #end

    @data = TransgroupAvg.all(:conditions => ["TRANSACTION_GROUP_ID = ?", key], 
            :order => 'COLLECT_DATE ASC')
  end

  def write
    # require 'gruff'
    Rails.logger.info "----- A ------"
    
#    g = Gruff::Line.new
#    g.title = @tg.name
    
    values = Array.new
    dates  = Hash.new
    
    @data.each do | e |
      values << e.sum_avg
    end

    dates[0] = @data[0].collect_date.mon.to_s + '-' + @data[0].collect_date.day.to_s
    dates[@data.size - 1] = @data[@data.size - 1].collect_date.mon.to_s + '-' + @data[@data.size - 1].collect_date.day.to_s
    
#    g.data("Total Process Waiting Time", values)
#    g.labels = dates
#    g.legend_font_size = 10
#    g.x_axis_label = "Days"
#    g.y_axis_label = "Milliseconds"
#    # g.title_font_size = 10
#    g.minimum_value = 0
#    g.write(filename)
    # ----------------------
    require 'rubygems'
    require 'google_chart'

    g = GoogleChart::LineChart.new("850x350", "", false)
    g.data "AVG/ms", values, '999999'
    # g.data "Line red", [2,4,0,6,9,3], 'ff0000'
    g.axis :y, :range => [0, values.max], :font_size => 10, :alignment => :center
    #g.show_legend = false
    g.shape_marker :circle, :color => '0000ff', :data_set_index => 0, :data_point_index => -1, :pixel_size => 10
    g.to_url

  end

end
