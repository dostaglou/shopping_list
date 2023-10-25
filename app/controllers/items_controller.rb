class ItemsController < ApplicationController
  before_action :set_list, only: %i[index new create edit update index]
  before_action :set_item, only: %i[edit update destroy update_status]

  def index
    items = case params[:order]
            when "a_to_z" then @list.items.order_by({ name: :asc})
            when "pending_to_retrieved" then @list.items.by_status
            when "pending_only" then @list.items.by_status.pending
            else @list.items.by_status
            end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("list_#{@list.id}", partial: "lists/list", locals: { list: @list, items: items, user: current_user, expanded: true })
      end
      format.html { redirect_to @list }
    end
  end

  def new
    @item ||= @list.items.new
  end

  def create
    @item = @list.items.new(item_params)

    if @item.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to lists_path }
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to lists_path }
      end
    else
      redirect_to lists_path
    end
  end

  def update_status
    if @item.update(status: params[:status].to_i)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to lists_path }
      end
    else
      redirect_to lists_path
    end
  end

  def destroy
    @item = Item.find(params[:id])
    shared_users = @item.shared_users

    if @item.destroy
      self.broadcast_destroy(shared_users)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to lists_path }
      end
    else
      redirect_to lists_path
    end
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    def set_list
      @list = List.find(params[:list_id])
    end

    def item_params
      params.require(:item).permit(:name, :note, :quantity)
    end

    def broadcast_destroy(shared_users)
      shared_users.each do |target_user|
       @item.broadcast_remove_to "user_#{target_user.id}_lists", target: "item_#{@item.id}"
      end
      @item.broadcast_remove_to "user_#{@item.list.user_id}_lists", target: "item_#{@item.id}"
    end
end
