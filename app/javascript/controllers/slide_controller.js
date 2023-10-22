import { Controller } from "@hotwired/stimulus";
import { enter, leave } from "el-transition";

export default class extends Controller {
  static values = { expanded: Boolean };
  static targets = ["container", "section", "content", "hideButton", "showButton" ];

  connect() {
    if (this.expandedValue) {
      this.containerTarget.classList.remove("h-0");
      this.containerTarget.classList.remove("hidden");
    }
    this.show()
  }

  show() {
    this.containerTarget.classList.remove("h-0");
    this.containerTarget.classList.remove("hidden");
    this.showButtonTarget.classList.add("hidden");
    this.hideButtonTarget.classList.remove("hidden");
    this.contentTargets.forEach(element => enter(element));
    this.sectionTargets.forEach(element => enter(element));
  }

  hide() {
    this.showButtonTarget.classList.remove("hidden");
    this.hideButtonTarget.classList.add("hidden");
    Promise.all([
      this.sectionTargets.forEach(element => leave(element)),
      this.contentTargets.forEach(element => leave(element)),
    ]).then(() => {
      this.containerTarget.classList.add("h-0");
      this.containerTarget.classList.add("hidden");
    });
  }
}
