class TransactionGroupItemsController < ApplicationController

	before_filter :find_trans_group

  # GET /transaction_group_items
  # GET /transaction_group_items.xml
  def index
    @transaction_group_items = @transgroup.transaction_group_items.find(:all, :order => "order_number ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transaction_group_items }
    end
  end

  # GET /transaction_group_items/1
  # GET /transaction_group_items/1.xml
  def show
    @transaction_group_item = TransactionGroupItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transaction_group_item }
    end
  end

  # GET /transaction_group_items/new
  # GET /transaction_group_items/new.xml
  def new
    @transaction_group_item = TransactionGroupItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transaction_group_item }
    end
  end

  # GET /transaction_group_items/1/edit
  def edit
    @transaction_group_item = TransactionGroupItem.find(params[:id])
  end

  # POST /transaction_group_items
  # POST /transaction_group_items.xml
  def create
    @transaction_group_item = TransactionGroupItem.new(params[:transaction_group_item])
    @transgroup.transaction_group_items << @transaction_group_item

    respond_to do |format|
      if @transgroup.save
        flash[:notice] = 'TransactionGroupItem was successfully created.'
        format.html { redirect_to(transaction_group_transaction_group_items_path) }
        format.xml  { render :xml => @transaction_group_item, :status => :created, :location => @transaction_group_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transaction_group_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transaction_group_items/1
  # PUT /transaction_group_items/1.xml
  def update
    @transaction_group_item = TransactionGroupItem.find(params[:id])

    respond_to do |format|
      if @transaction_group_item.update_attributes(params[:transaction_group_item])
        flash[:notice] = 'TransactionGroupItem was successfully updated.'
        format.html { redirect_to(transaction_group_transaction_group_items_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction_group_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transaction_group_items/1
  # DELETE /transaction_group_items/1.xml
  def destroy
    @transaction_group_item = TransactionGroupItem.find(params[:id])
    @transaction_group_item.destroy

    respond_to do |format|
      format.html { redirect_to(transaction_group_transaction_group_items_url) }
      format.xml  { head :ok }
    end
  end

  private 
  def find_trans_group
    group_id = params[:transaction_group_id] 
    return(redirect_to(transaction_group_url)) unless group_id 
    @transgroup = TransactionGroup.find(group_id) 
  end


end
