import { Controller } from "@hotwired/stimulus";
import { put } from "@rails/request.js";
import Sortable from "sortablejs";

export default class extends Controller {
  static values = { url: String, id: Number };

  connect() {
    this.sortable = Sortable.create(this.element, {
      onEnd: this.onEnd.bind(this),
      handle: "[data-sortable-handle]",
    });
  }

  disconnect() {
    this.sortable.destroy();
  }

  onEnd(event) {
    const { newIndex, item } = event;
    const id = item.dataset["sortableId"];
    const url = this.urlValue.replace(":id", id);
    put(url, {
      body: JSON.stringify({ position: newIndex }),
    });
  }
}
