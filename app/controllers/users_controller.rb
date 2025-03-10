class UsersController < ApplicationController
    before_action :set_user, only: %i[show destroy]

    def index
        @users = User.all
    end

    def show
        @articles = Article.where(user_id: @user.id)
    rescue ActiveRecord::RecordNotFound
        not_found_method
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
        @user.destroy
        redirect_to users_path
    end

    private

    def set_user
        @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        not_found_method
    end

    def user_params
        params.require(:user).permit(:name, :email, :password)
    end

    def not_found_method
        render file: Rails.public_path.join("404.html"), status: :not_found, layout: true
    end
end

