class TransactionGroupsController < ApplicationController
  # GET /transaction_groups
  # GET /transaction_groups.xml
  def index
    @transaction_groups = TransactionGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transaction_groups }
    end
  end

  # GET /transaction_groups/1
  # GET /transaction_groups/1.xml
  def show
    @transaction_group = TransactionGroup.find(params[:id])
    #@transaction_group.transaction_group_items.all :joins => :transhist #, :conditions => {'transhist.collect_date' => time_range}
    @transaction_group.transaction_group_items.all
    #@tran_avg = TransgroupAvg.all(:conditions => ["TRANSACTION_GROUP_ID = ? and collect_date > ?", params[:id], DateTime.now - 20.days], :order => 'COLLECT_DATE DESC')
    
    # get the chart
    mgr = GraphTransactionGroup.new
    mgr.getData(params[:id])

    @google_url = mgr.write

    @trans = mgr.trans

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transaction_group }
    end
  end

  # GET /transaction_groups/new
  # GET /transaction_groups/new.xml
  def new
    @transaction_group = TransactionGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transaction_group }
    end
  end

  # GET /transaction_groups/1/edit
  def edit
    @transaction_group = TransactionGroup.find(params[:id])
  end

  # POST /transaction_groups
  # POST /transaction_groups.xml
  def create
    @transaction_group = TransactionGroup.new(params[:transaction_group])

    respond_to do |format|
      if @transaction_group.save
        flash[:notice] = 'TransactionGroup was successfully created.'
        format.html { redirect_to(@transaction_group) }
        format.xml  { render :xml => @transaction_group, :status => :created, :location => @transaction_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transaction_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transaction_groups/1
  # PUT /transaction_groups/1.xml
  def update
    @transaction_group = TransactionGroup.find(params[:id])

    respond_to do |format|
      if @transaction_group.update_attributes(params[:transaction_group])
        flash[:notice] = 'TransactionGroup was successfully updated.'
        format.html { redirect_to(@transaction_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transaction_groups/1
  # DELETE /transaction_groups/1.xml
  def destroy
    @transaction_group = TransactionGroup.find(params[:id])
    @transaction_group.destroy

    respond_to do |format|
      format.html { redirect_to(transaction_groups_url) }
      format.xml  { head :ok }
    end
  end
end
