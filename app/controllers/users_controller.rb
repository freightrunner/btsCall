class UsersController < ApplicationController
    before_action :set_user, only: [:show, :destroy] #might need to include :edit, :update
    before_action :check_admin, only: [:index]
    
    def index
        @users = User.all.order('LOWER(username)')
    end
    
    def show
    end
    
#    def edit
#    end
    
#    def update
#    respond_to do |format|
#      if @user.update(user_params)
#        format.html { redirect_to @user, notice: 'User was successfully updated.' }
#        format.json { render :show, status: :ok, location: @user }
#      else
#        format.html { render :edit }
#        format.json { render json: @user.errors, status: :unprocessable_entity }
#      end
#    end
#    end
  
    def destroy
        @user.destroy
        respond_to do |format|
          format.html { redirect_to users_path, notice: 'User was successfully destroyed.' }
          format.json { head :no_content }
        end
    end
    
    private
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def check_admin
        @chkAcct = current_user
        @chkAcct.admin == true
    end
    
end