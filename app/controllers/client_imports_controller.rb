class ClientImportsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @client_import = ClientImport.new
  end

  def create
    @client_import = ClientImport.new(params[:client_import])
    if @client_import.save
      redirect_to root_url, notice: "Imported clients successfully."
    else
      render :new
    end
  end
end