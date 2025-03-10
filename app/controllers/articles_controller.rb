class ArticlesController < ApplicationController
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

  def edit
    begin
      @article = Article.find(params[:id])
    rescue
      not_found_method
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    article = Article.find(params[:id])
    user = article.user_id
    article.destroy
    redirect_to user_path(user)
  end
  
  def not_found_method
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: true
  end

  private
    def article_params
      params.expect(article: [:title, :content, :user_id])
    end
end
