class StatsController < ApplicationController

  def index
    @system_list = [
          ['PeopleSoft Online',   'PSFT-OL'],
          ['PeopleSoft Batch',    'PSFT-BT'],
          ['PeopleSoft Ext Calls','PSFT-EX'],
          ['WebShop',             'WSHOP'],
          ['Selfcare',            'SCARE']]
          
    # get the period, default is 7 days
    @system_curr = params[:system_name]
    @system_curr = 'PSFT-OL' if @system_curr.nil? # || @system_curr not in list

    @trans = TranshistTopAvg.find(:all, :conditions => ['SYSTEM_NAME = ? AND rownum < 101', @system_curr])
    @date = Transhist.maximum("COLLECT_DATE")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trans }
    end
  end

# active_scaffold :transhist_top_avg do |config|
#     config.label = "PeopleSoft CRM Top Transactions"
#     config.columns = [:id, :pm_context_value1, :pm_context_value2, :pm_context_value3, :sum_avg]
#     config.action_links.add 'export_csv', :label => 'Export to Excel', :page => true
#     #config.modules.exclude :update
#      config.actions.exclude :create, :delete, :update
#       config.create.link 'get_pdf', :label => 'Download PDF'
#      config.show.link.parameters # :transhist
#      config.action_links[:display] = 
#      list.columns.exclude :comments
#      list.sorting = {:name => 'ASC'}
#      columns[:phone].label = "Phone #"
#      columns[:phone].description = "(Format: ###-###-####)"
#   end

#  def index
#    @trans = TranshistTopAvg.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @trans }
#    end
#  end

  def export_csv
      # find_page is how the List module gets its data. see Actions::List#do_list.
      records = find_page().items
      return if records.size == 0

      # Note this code is very generic.  We could move this method and the
      # action_link configuration into the ApplicationController and reuse it
      # for all our models.
      data = ""
      cls = records[0].class
      data << cls.csv_header << "\r\n"
      records.each do |inst|
        data << inst.to_csv << "\r\n"
      end
      send_data data, :type => 'text/csv', :filename => cls.name.pluralize + '.csv'
    end
end
