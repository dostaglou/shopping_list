class ListsController < ApplicationController
  before_action :set_list, only: [:edit, :update, :show, :destroy]

  def index
    records = policy_scope(List)
    @pagy, @lists = pagy(records, items: 6)
    @lists
  end

  def new
    @list ||= List.new
  end

  def edit
  end

  def update
    if @list.update(list_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to lists_path }
      end
    else
      render :edit
    end
  end

  def create
    @list = current_user.lists.new(list_params)
    if @list.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to lists_path }
      end
    else
      render :new
    end
  end

  def destroy
    if @list.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to lists_path }
      end
    else
      redirect_to lists_path
    end
  end


  private
    def set_list
      @list = current_user.lists.find(params[:id])
    end

    def list_params
      params.require(:list).permit(:title)
    end
end
