import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="suggestion-selector"
export default class extends Controller {
  static targets = ["input"];
  select(e) {
    this.inputTarget.value = e.target.innerText;
  }
}
