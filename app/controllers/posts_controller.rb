# encoding: utf-8
class PostsController < ApplicationController

  layout 'shared/home'

  before_action :load_posts, only: [:index, :show, :edit, :update, :destroy]
  before_action :load_blogger, only: [:show]

  def index
    @posts = @posts.page(params[:page])
  end

  def new
    @post = resource_class.new
  end

  def show
    @post = @posts.find(params[:id])
    @reply = Reply.new(post_id: @post.id)
    @replies = Reply.includes(:user).where(replies: {post_id: params[:id]})#@post.replies
  end
  #
  # protected
  # # override super method
  def load_blogger
    if params[:user_id].present?
      @blogger = User.find(params[:user_id])
    else
      @post = resource_class.find(params[:id])
      @blogger = @post.user
    end
  end

  def create
    @post = resource_class.new(post_params)
    @post.user = current_user

    if @post.save
      flash[:notice] = '你已经成功发布了文章。'
      redirect_to admin_post_path(@post)
    else
      add_error_to_flash
      render :new
    end
  end

  def edit
    @post = @posts.find(params[:id])
  end

  def update
    @post = @posts.find(params[:id])

    if @post.update_attributes(post_params)
      flash[:notice] = '你已经成功修改了文章。'
      redirect_to action: :show
    else
      add_error_to_flash
      render :edit
    end
  end

  def destroy
    @post = @posts.find(params[:id])
    @post.destroy

    flash[:notice] = '你已经成功删除了该文章。'
    redirect_to admin_root_path
  end

  private
  def load_posts
    @posts ||= (resource_class.all.order('updated_at desc') || current_user.posts) #TODO refine, suck here
  end

  def post_params
    params.require(:post).permit(:user_id, :point_id, :category_id, :source, :title, :content, :tags)
  end

  def add_error_to_flash
    if @post.errors[:base].present?
      flash.now[:error] = @post.errors[:base].first
    else
      flash.now[:error] = draw_errors_message(@post)
    end
  end

end
