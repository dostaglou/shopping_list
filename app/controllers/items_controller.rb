class ItemsController < ApplicationController
  before_action :set_list, only: %i[index new create update index]
  before_action :update_list, only: [:delete]

  def index
    items = case params[:order]
            when "a_to_z" then @list.items.order_by({ name: :asc})
            when "pending_to_retrieved" then @list.items.by_status
            when "pending_only" then @list.items.by_status.pending
            else @list.items.by_status
            end

    puts "\n\n\n#{items.pluck(:name)}\n\n\n"

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("list_#{@list.id}", partial: "lists/list", locals: { list: @list, items: items, expanded: true })
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
  end

  def update_status
    item = Item.find(params[:id])

    if item.update(status: params[:status].to_i)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to lists_path }
      end
    else
      redirect_to lists_path
    end
  end

  def destroy
    item = Item.find(params[:id])
    if item.destroy
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
      @list = List.find(params[:list_id])
    end

    def item_params
      params.require(:item).permit(:name, :note, :quantity)
    end
end
