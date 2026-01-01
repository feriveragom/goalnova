/**
 * Flash Hook - Auto-dismiss flash messages after 8 seconds
 */
export const Flash = {
  mounted() {
    this.timeout = setTimeout(() => {
      this.el.click() // Triggers the phx-click to clear the flash
    }, 8000)
  },
  destroyed() {
    if (this.timeout) clearTimeout(this.timeout)
  }
}

