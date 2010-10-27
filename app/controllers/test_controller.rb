class TestController < ApplicationController

 active_scaffold :transhist_top_avg do |config|
     config.label = "PeopleSoft CRM Top Transactions"
     config.columns = [:id, :pm_context_value1, :pm_context_value2, :pm_context_value3, :sum_avg]
#    config.action_links.add 'export_csv', :label => 'Export to Excel', :page => true
#    #config.modules.exclude :update
#     config.actions.exclude :create, :delete, :update
#      config.create.link 'get_pdf', :label => 'Download PDF'
#     config.show.link.parameters # :transhist
#     config.action_links[:display] = 
#     list.columns.exclude :comments
#     list.sorting = {:name => 'ASC'}
#     columns[:phone].label = "Phone #"
#     columns[:phone].description = "(Format: ###-###-####)"
   end
end
