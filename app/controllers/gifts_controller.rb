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

  # GET /gifts/1/buy
	def buy
	  good = false
	  gift = nil
	  begin
      gift = Gift.find(params[:id])
    end
    if !gift.nil? and gift.user_id != current_user.id
      if !gift.bought_by_id
        gift.bought_by_id = current_user.id
        gift.bought_date = DateTime.now
        good = true
      end
    end
    
    user = nil
    if !gift.nil?
      user = gift.user
    elsif params[:user_id]
      begin
        user = User.find(params[:user_id])
      end
    end
    
    respond_to do |format|
      if good and gift.save
        format.html { redirect_to(user_gifts_path(user), :notice => 'Gift was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { redirect_to(user_gifts_path(user), :error => 'There was an eeror marking this gift bought.') }
        format.xml  { render :xml => gift.errors, :status => :unprocessable_entity }
      end
    end
	end

  # GET /gifts/1/unbuy
	def unbuy
	  good = false
	  gift = nil
	  begin
      gift = Gift.find(params[:id])
    end
    if !gift.nil? and gift.user_id != current_user.id
      logger.info gift.bought_by_id.inspect
      logger.info current_user.inspect
      if gift.bought_by_id == current_user.id
        logger.info 'there'
        gift.bought_by_id = nil
        gift.bought_date = nil
        good = true
      end
    end
    
    user = nil
    if !gift.nil?
      user = gift.user
    elsif params[:user_id]
      begin
        user = User.find(params[:user_id])
      end
    end

    respond_to do |format|
      if good and gift.save
        format.html { redirect_to(user_gifts_path(user), :notice => 'Gift was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { redirect_to(user_gifts_path(user), :error => 'There was an eeror marking this gift bought.') }
        format.xml  { render :xml => gift.errors, :status => :unprocessable_entity }
      end
    end
	end

end
