import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="suggestion-selector"
export default class extends Controller {
  static targets = ["alt"];
  select(e) {
    this.altTarget.value = e.target.innerText;
  }
}
