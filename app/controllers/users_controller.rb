class UsersController < ApplicationController
    
    before_action :check_admin, only: [:index]
    
    def index
        @users = User.all
    end
    
    
    
    private
    
    def check_admin
        @chkAcct = current_user
        @chkAcct.admin == true
    end
    
end