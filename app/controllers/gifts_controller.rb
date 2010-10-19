class GiftsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # GET /gifts
  # GET /gifts.xml
  def index
    @user_id = params[:user_id]
    @user = User.find_by_id(params[:user_id])
    @gifts = Gift.paginate :conditions => {:user_id => params[:user_id]}, :page => params[:page], :order => 'created_at ASC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @gifts }
    end
  end

  # GET /gifts/1
  # GET /gifts/1.xml
  def show
    @gift = Gift.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gift }
    end
  end

  # GET /gifts/new
  # GET /gifts/new.xml
  def new
    @gift = Gift.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gift }
    end
  end

  # GET /gifts/1/edit
  def edit
    @gift = Gift.find(params[:id])
  end

  # POST /gifts
  # POST /gifts.xml
  def create
    @gift = Gift.new(params[:gift])
    @gift.user_id = current_user

    respond_to do |format|
      if @gift.save
        format.html { redirect_to(user_gifts_path(current_user), :notice => 'Gift was successfully created.') }
        format.xml  { render :xml => @gift, :status => :created, :location => @gift }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gift.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /gifts/1
  # PUT /gifts/1.xml
  def update
    @gift = Gift.find(params[:id])

    respond_to do |format|
      if @gift.update_attributes(params[:gift])
        format.html { redirect_to(user_gifts_path(current_user), :notice => 'Gift was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gift.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gifts/1
  # DELETE /gifts/1.xml
  def destroy
    @gift = Gift.find(params[:id])
    if @gift.user_id == current_user.id
      @gift.destroy
    end

    respond_to do |format|
      format.html { redirect_to(user_gifts_path(current_user)) }
      format.xml  { head :ok }
    end
  end
end
