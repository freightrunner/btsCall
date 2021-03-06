class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index, :search, :new, :create]
  before_action :set_client_user, only: [:show, :edit]
  before_action :check_admin, only: [:destroy, :import]
  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all.order('LOWER(name)').includes(:user)
    if params[:q]
      @term = "#{params[:q]}"
      @clients = @clients.search(params[:q])
    elsif params[:user_id]
      @clients = @clients.my_leads(params[:user_id])
    elsif params[:category]
      @clients = @clients.category_filter(params[:category])
    end
  end

  def myClients
    @myClients = Client.where(user_id: current_user.id).all
    @myClients = @myClients.where(status: 'open').all
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @notes = @client.notes.all
    @contacts = @client.contacts.all
  end

  def search
    @clients = Client.all
    respond_to do |format|
      format.html
      format.json { @clients = Client.search(params[:w]) }
    end
  end

  # GET /clients/new
  def new
    @client = Client.new
    @clientOwner = User.find(current_user.id)
  end

  # GET /clients/1/edit
  def edit
    if @client.user_id?
      @clientOwner = User.find(@client.user_id)
      else
      @clientOwner = current_user
    end
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)
    #@client.user_id = @clientOwner

    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to @client, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    Client.import(params[:file])
    redirect_to clients_path, notice: "Companies imported"
  end

  private
  
    def check_admin
      @checkAcct = current_user
      @checkAcct.admin? == true
    end

    #def current_username
     # @currentUsername = current_user.username
    #end

    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    def set_client_user
      if @client.user_id?
        @clientOwner = User.find(@client.user_id)
        else
        @clientOwner = current_user
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :address, :status, :user_id, :category, :main_phone, :email_domain, :revenue)
    end
end
