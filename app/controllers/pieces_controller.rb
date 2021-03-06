class PiecesController < ApplicationController
  before_filter :authenticate_admin!, :only => [:new,:edit,:create,:destroy,:update,:all]
  def show
    if params[:issue_title] && params[:piece_title] 
      @piece=get_piece_from_titles(params)
      raise ActionController::RoutingError.new('Piece not found') if @piece.nil?
    else
      @piece=Piece.find(params[:id])
    end
    if !@piece.is_published && !admin_signed_in?
      redirect_to '/'
    end    
  end

  def new
    @piece=Piece.new
    @authors=Author.all
    @issues=Issue.all
  end

  def edit
    @piece=Piece.find(params[:id])
  end

  def create
    saved=Piece.new(params[:piece]).save()
    if saved
      redirect_to :controller=>'issues', :action => 'show', :id=>params[:piece][:issue_id]
    else #form had errors
      render :acion=>'new'
    end
  end
  
  def update
    @piece=Piece.find(params[:id])
    saved=@piece.update_attributes(params[:piece])
    if saved
      redirect_to "/pieces/#{@piece.id}"
    else
      redirect_to "/pieces/#{@piece.id}/edit"
    end
  end
  
  def destroy
    Piece.find(params[:id]).delete
    respond_to do |format|
      format.html { redirect_to '/' }
      format.js do
        render :nothing => true, :status => :ok
        return true
      end
    end
  end
  
  def all
    @pieces=Piece.all
  end
end
