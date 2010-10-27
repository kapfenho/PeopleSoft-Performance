class RecurrencesController < ApplicationController

	before_filter :find_jobdef
  
  def index
    @recurrs = @jobdefn.recurrences.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @recurrs }
    end
  end

  def show
    @recurr = Recurrence.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @recurr }
    end
  end

  def new
		@recurr = Recurrence.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recurr }
    end
  end

  def edit
    @recurr = Recurrence.find(params[:id])
  end

  def create
    @recurr = Recurrence.new(params[:recurrence])
    #@recurr.jobdefinition_id = @jobdefn.id
    @jobdefn.recurrences << @recurr

#		@service = ArtworkPictureService.new(@artwork_picture, @picture)

    respond_to do |format|
      if @jobdefn.save
        flash[:notice] = 'Recurrence was successfully created.'
        format.html { redirect_to jobdefinition_recurrences_path }
        format.xml  { render :xml => @recurr, :status => :created, :location => @recurr }
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @recurr.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @recurr = Recurrence.find(params[:id])
		
	  respond_to do |format|
      if @recurr.update_attributes(params[:recurrence])
        flash[:notice] = 'Recurrence was successfully updated.'
        format.html { redirect_to jobdefinition_recurrences_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recurr.errors, :status => :unprocessable_entity }
      end
		end
  end

  # DELETE /artwork_pictures/1
  # DELETE /artwork_pictures/1.xml
  def destroy
    @recurr = Recurrence.find(params[:id])
    @recurr.destroy

    respond_to do |format|
      format.html { redirect_to(jobdefinition_recurrences_path) }
      format.xml  { head :ok }
    end
  end

  private 
  def find_jobdef
    jobdef_id = params[:jobdefinition_id] 
    return(redirect_to(jobdefinition_url)) unless jobdef_id 
    @jobdefn = Jobdefinition.find(jobdef_id) 
  end

end
