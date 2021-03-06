# frozen_string_literal: true

# Allows tags for forum and agreements to be created by admins
class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :find_tag_or_redirect, only: [:show, :edit, :update, :destroy]

  layout "layouts/full_page_sidebar"

  # GET /tags
  def index
    scope = Tag.current.search(params[:search])
    @tags = scope_order(scope).page(params[:page]).per(40)
  end

  # # GET /tags/1
  # def show
  # end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # # GET /tags/1
  # def edit
  # end

  # POST /tags
  def create
    @tag = current_user.tags.new(tag_params)
    if @tag.save
      redirect_to @tag, notice: "Tag was successfully created."
    else
      render :new
    end
  end

  # PATCH /tags/1
  def update
    if @tag.update(tag_params)
      redirect_to @tag, notice: "Tag was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /tags/1
  def destroy
    @tag.destroy
    redirect_to tags_path, notice: "Tag was successfully deleted."
  end

  private

  def find_tag_or_redirect
    @tag = Tag.current.find_by(id: params[:id])
    redirect_without_tag
  end

  def redirect_without_tag
    empty_response_or_root_path(tags_path) unless @tag
  end

  def tag_params
    params.require(:tag).permit(:name, :color, :tag_type)
  end

  def scope_order(scope)
    @order = params[:order]
    scope.order(Arel.sql(Tag::ORDERS[params[:order]] || Tag::DEFAULT_ORDER))
  end
end
