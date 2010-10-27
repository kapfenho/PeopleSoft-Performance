class TranshistMgr # < ActiveRecord::Base

  attr_accessor :trans

  def getTranshists(pm1, pm2, pm3)
    @transname = pm1 + "--" + pm2 + "--" + pm3
    @hists = Transhist.all :conditions => ["pm_context_value1 = ? AND pm_context_value2 = ? AND pm_context_value3 = ? and counter > 1 and collect_date > sysdate - ?", 
              pm1, pm2, pm3, 40], :order => "collect_date ASC"
    @trans = Transaction.first :conditions => ["pm_context_value1 = ? AND pm_context_value2 = ? AND pm_context_value3 = ?", 
                        pm1, pm2, pm3]
  end

  def write

    values = Array.new
    counters = Array.new
    dates  = Array.new
    
    @hists.each do | e |
      values << e.average
      dates << e.collect_date.mon.to_s + '-' + e.collect_date.day.to_s
      counters << e.counter
    end

    # dates[0] = @hists[0].collect_date.mon.to_s + '-' + @hists[0].collect_date.day.to_s
    # dates[@hists.size - 1] = @hists[@hists.size - 1].collect_date.mon.to_s + '-' + @hists[@hists.size - 1].collect_date.day.to_s
    
#    i = 0
#    while i < @hists.size
#      dates[i] = @hists[i].collect_date.to_s
#      i = i + 1
#    end

#    # g.data(@transname, values)
#    g.data("Average transaction response time", values)
#    # g.data("Number of transactions meassured", counters)
#    g.labels = dates
#    g.legend_font_size = 10
#    g.x_axis_label = "Days"
#    g.y_axis_label = "Milliseconds"
#    # g.title_font_size = 10
#    g.minimum_value = 0
#    g.write(filename)

    require 'rubygems'
    require 'google_chart'

    if @trans.nil?
      title = "Transaction Response Time"
    else
      title = @trans.description
    end

    g = GoogleChart::LineChart.new("850x350", title, false)
    g.data "AVG/ms", values, '999999'
    # g.data "Line red", [2,4,0,6,9,3], 'ff0000'
    g.axis :y, :range => [0, values.max], :font_size => 10, :alignment => :center
    g.axis :x, :labels =>  dates
    g.grid :y_step => 100, :y_step => 10, :length_segment => 1, :length_blank => 0
    #g.show_legend = false
    g.shape_marker :circle, :color => '0000ff', :data_set_index => 0, :data_point_index => -1, :pixel_size => 10
    g.to_url
  end

end
