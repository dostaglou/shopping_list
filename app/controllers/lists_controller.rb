class ListsController < ApplicationController
  def index
    records = policy_scope(List)
    @pagy, @lists = pagy(records, items: 6)
    @lists
  end

  def new
    @list ||= List.new
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


  private
    def set_list

    end

    def list_params
      params.require(:list).permit(:title)
    end
end
