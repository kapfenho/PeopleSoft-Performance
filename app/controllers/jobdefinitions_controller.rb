class JobdefinitionsController < ApplicationController

  def index
    @jobdefinitions = Jobdefinition.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobdefinitions }
    end
  end

  def show
    @jobdefinition = Jobdefinition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @jobdefinition }
    end
  end

  def new
    @jobdefinition = Jobdefinition.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @jobdefinition }
    end
  end

  def edit
    @jobdefinition = Jobdefinition.find(params[:id])
  end

  def create
    @jobdefinition = Jobdefinition.new(params[:jobdefinition])

    respond_to do |format|
      if @jobdefinition.save
        flash[:notice] = 'Jobdefinition was successfully created.'
        format.html { redirect_to(@jobdefinition) }
        format.xml  { render :xml => @jobdefinition, :status => :created, :location => @jobdefinition }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @jobdefinition.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @jobdefinition = Jobdefinition.find(params[:id])

    respond_to do |format|
      if @jobdefinition.update_attributes(params[:jobdefinition])
        flash[:notice] = 'Jobdefinition was successfully updated.'
        format.html { redirect_to(@jobdefinition) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @jobdefinition.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @jobdefinition = Jobdefinition.find(params[:id])
    @jobdefinition.destroy

    respond_to do |format|
      format.html { redirect_to(jobdefinitions_url) }
      format.xml  { head :ok }
    end
  end
  
end
