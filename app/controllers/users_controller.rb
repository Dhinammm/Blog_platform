class UsersController < ApplicationController
    allow_unauthenticated_access except: %i[ destroy ]
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
        auth_user =User.find_by(id: session[:user_id])
        if auth_user.nil?
            redirect_to new_session_path
        else
            session[:user_id] = nil
            if user.id != auth_user.id
                redirect_to new_session_path
            else
                user.destroy
                redirect_to users_path
            end
        end
    end

    private
    def user_params
        params.expect(user: [:name, :email_address, :password])
    end
end
