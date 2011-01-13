class TransactionsController < ApplicationController

  def new
    @trans = Transaction.new(:system_name => params[:system_name], :pm_transaction => params[:pm_transaction])
    respond_to do |format|
      format.html
      format.xml  { render :xml => @trans }
    end
  end

  def edit
    @trans = 
      Transaction.first :conditions => ["system_name = ? AND pm_transaction = ?", 
                      params[:system_name], params[:pm_transaction]]
    respond_to do |format|
      format.html
      format.xml  { render :xml => @trans }
    end
  end

  def create
    @trans = Transaction.new(params[:transaction])

    respond_to do |format|
      if @trans.save
        flash[:notice] = 'Transaction was successfully created.'
        format.html { redirect_to(:controller => :stats, :action => :index)  }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trans.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @trans = Transaction.find(params[:id])

    respond_to do |format|
      if @trans.update_attributes(params[:transaction])
        flash[:notice] = 'Transaction was successfully updated.'
        format.html { redirect_to(:controller => :stats, :action => :index) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trans.errors, :status => :unprocessable_entity }
      end
    end
  end

#  active_scaffold :transaction do |config|
#      config.label = "PeopleSoft CRM Transactions"
#      config.columns = [:description, :pm_context_value1, :pm_context_value2, :pm_context_value3, :notes]
##      list.columns.exclude :comments
##      list.sorting = {:name => 'ASC'}
##      columns[:phone].label = "Phone #"
##      columns[:phone].description = "(Format: ###-###-####)"
#    end

end
