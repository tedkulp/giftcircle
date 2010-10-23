class CirclesController < ApplicationController

  before_filter :authenticate_user!

  # GET /circles
  # GET /circles.xml
  def index
    @circles = current_user.circles

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @circles }
    end
  end

  # GET /circles/1
  # GET /circles/1.xml
  def show
    @circle = Circle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @circle.to_xml(:include => :users) }
    end
  end

  # GET /circles/new
  # GET /circles/new.xml
  def new
    @circle = Circle.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @circle }
    end
  end

  # GET /circles/1/edit
  def edit
    @circle = Circle.find(params[:id])
  end

  # POST /circles
  # POST /circles.xml
  def create
    @circle = Circle.new(params[:circle])
    @circle.admin_user_id = current_user.id
    @circle.created_by = current_user

    respond_to do |format|
      if @circle.save
        user_circle = UserCircle.new
        user_circle.circle_id = @circle.id
        user_circle.user_id = @circle.admin_user_id
        user_circle.save
        format.html { redirect_to(circles_path, :notice => 'Circle was successfully created.') }
        format.xml  { render :xml => @circle, :status => :created, :location => @circle }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @circle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /circles/1
  # PUT /circles/1.xml
  def update
    @circle = Circle.find(params[:id])

    respond_to do |format|
      if @circle.update_attributes(params[:circle])
        format.html { redirect_to(circles_path, :notice => 'Circle was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @circle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /circles/1
  # DELETE /circles/1.xml
  def destroy
    @circle = Circle.find(params[:id])
    if current_user.id == @circle.admin_user_id
      @circle.destroy
    end

    respond_to do |format|
      format.html { redirect_to(circles_url) }
      format.xml  { head :ok }
    end
  end
  
  def remove_user
    user_circle = UserCircle.find(:first, :conditions => ["circle_id = ? AND user_id = ?", params[:circle_id], params[:id]])
    
    respond_to do |format|
      if user_circle and user_circle.destroy
        format.html { redirect_to(circle_path(params[:circle_id]), :notice => 'User was successfully removed.') }
        format.xml  { head :ok }
      else
        format.html { redirect_to(circle_path(params[:circle_id]), :notice => 'User was not able to be removed.') }
        format.xml  { render :xml => @circle.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
