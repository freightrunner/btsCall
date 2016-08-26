class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index, :search, :new, :create]
  before_action :set_client_user, only: [:show, :edit]
  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    #if @client.user_id?
      #@clientOwner = User.find(@client.id)
      #else
      #@clientOwner = "No user associated"
    #end
  end

  def search
    @clients = Client.all
    if params[:q]
      @results = Client.search(params[:q]).first
      if @results.blank?
        @response = 8
      else
        @response = @results
      end
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
        format.html { redirect_to @client, notice: 'Client was successfully created.' }
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
        format.html { redirect_to @client, notice: 'Client was successfully updated.' }
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
    redirect_to clients_path, notice: "Clients imported"
  end

  private

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
      params.require(:client).permit(:name, :address, :status, :user_id)
    end
end
