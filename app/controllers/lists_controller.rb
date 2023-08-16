class ListsController < ApplicationController
  def index
    records = policy_scope(List)
    @pagy, @lists = pagy(records, items: 6)
  end
end
