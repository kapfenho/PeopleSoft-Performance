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
    @period_list = [['7 days',7],['14 days',14],['31 days',30],['3 months',60],['6 months',180]]

    # get description data
    @transaction_group = TransactionGroup.find(params[:id])
    @transaction_group.transaction_group_items.all
    
    # get the period, default is 7 days
    @period_curr = params[:period].to_i
    @period_curr = 7 if @period_curr.nil? || @period_curr == 0

    mgr = GraphTransactionGroup.new
    mgr.getData(@transaction_group, @period_curr)
    @google_url = mgr.write

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
