class ArticlesController < ApplicationController
    before_action :set_article, only: %i[show edit update destroy]

    def index
        @articles = Article.all
    end

    def show
        @user = @article.user_id
    rescue ActiveRecord::RecordNotFound
        not_found_method
    end

    def new
        @article = Article.new
    end

    def create
        @article = Article.new(article_params)
        if @article.save
            redirect_to @article
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit; end

    def update
        if @article.update(article_params)
            redirect_to @article
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        user = @article.user_id
        @article.destroy
        redirect_to user_path(user)
    end

    private

    def set_article
        @article = Article.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        not_found_method
    end

    def article_params
        params.require(:article).permit(:title, :content, :user_id)
    end

    def not_found_method
        render file: Rails.public_path.join("404.html"), status: :not_found, layout: true
    end
end

