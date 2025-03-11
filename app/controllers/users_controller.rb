class UsersController < ApplicationController
    def index
        @user = User.all
    end

    def show
        begin
            @user = User.find(params[:id])
            @article = Article.where("user_id = ?",params[:id])
        rescue
            render file:Rails.public_path.join('404.html'), status: :not_found, layout: true
        end
    end

    def new 
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            redirect_to @user
        else
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        user = User.find(params[:id])
        user.destroy
        redirect_to users_path
    end

    private
    def user_params
        params.expect(user: [:name, :email, :password])
    end
end
