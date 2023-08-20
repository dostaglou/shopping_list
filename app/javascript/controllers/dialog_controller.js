import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dialog"
export default class extends Controller {
  static targets = ["dialog", "modalBox"]

  connect() {
    this.dialogTarget.showModal()
    this.element.addEventListener("turbo:submit-end", (event) => {
      if (event.detail.success) {
        this.close()
      }
    })
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
