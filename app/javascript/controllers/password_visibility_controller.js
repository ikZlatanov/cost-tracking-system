import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // This tells Stimulus to look for an element labeled "input"
  static targets = [ "input" ]

  toggle() {
    if (this.inputTarget.type === "password") {
      this.inputTarget.type = "text"
    } else {
      this.inputTarget.type = "password"
    }
  }
}