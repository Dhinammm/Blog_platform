class ArticlesController < ApplicationController
    allow_unauthenticated_access only: %i[ index show not_found_method ]

    def index
        @article = Article&.all
    end

    def show
        begin
            @article = Article&.find(params[:id])
            @user = @article.user_id
        rescue
            not_found_method
        end
    end

    def new
        user = User.find_by(id: params[:user_id])
        if user.id != session[:user_id]
            redirect_to new_session_path
        else
            @article = Article.new
        end
    end

    def create
        @article = Article.new(article_params)
        if @article.save
            redirect_to @article
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @article = Article&.find(params[:id])
        if @article&.user_id != session[:user_id]
            redirect_to new_session_path
        end
    end

    def update
        @article = Article&.find(params[:id])
        if @article.update(article_params)
            redirect_to @article
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @article = Article&.find(params[:id])
        if @article.user_id != session[:user_id]
            redirect_to new_session_path
        else
            article = @article
            user = article.user_id
            if user != session[:user_id]
                redirect_to new_session_path
            else
                article.destroy
                redirect_to user_path(user)
            end
        end
    end

    def not_found_method
        render file: Rails.public_path.join('404.html'), status: :not_found, layout: true
    end

    private
    def article_params
        params.expect(article: [:title, :content, :user_id])
    end
end
