import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dialog"
export default class extends Controller {
  static targets = ["dialog", "modalBox"]

  connect() {
    this.dialogTarget.showModal()
  }

  open() {
    this.dialogTarget.showModal()
  }

  close() {
    this.dialogTarget.close()
  }

  outsideClick(event) {
    let inside = this.modalBoxTarget.contains(event.target) || this.modalBoxTarget === event.target

    if (!inside) { this.close() }
  }
}
