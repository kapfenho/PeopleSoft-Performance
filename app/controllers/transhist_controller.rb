class TranshistController < ApplicationController

  def show
    mgr = TranshistMgr.new
    mgr.getTranshists(params[:id1], params[:id2], params[:id3])
    @graph_url = mgr.write
    @trans = mgr.trans

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trans }
    end
  end

  def index
    mgr = TranshistMgr.new
    mgr.getTranshists(
      "AT_CMP_ACTIV_SERCH.GBL", 
      "AT_STP_ACTIV_SERCH", 
      "Click Prompt Button/Hyperlink for Field RB_FLT_CRIT_WRK.RA_VALUE_PROMPT")
    mgr.write('public/images/mygraph.png')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trans }
    end
  end
    
end
