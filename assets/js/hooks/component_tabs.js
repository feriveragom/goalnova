/**
 * ComponentTabs Hook
 * 
 * Maneja el cambio de tabs internos en componentes de demo.
 * Se ejecuta cada vez que el componente se monta o actualiza.
 */
export const ComponentTabs = {
  mounted() {
    this.initTabs()
  },

  updated() {
    this.initTabs()
  },

  initTabs() {
    const tabButtons = this.el.querySelectorAll('.tab-button')
    const tabContents = this.el.querySelectorAll('.tab-content')

    // Remove existing listeners to prevent duplicates
    tabButtons.forEach(button => {
      const newButton = button.cloneNode(true)
      button.parentNode.replaceChild(newButton, button)
    })

    // Re-query after cloning
    const freshTabButtons = this.el.querySelectorAll('.tab-button')

    freshTabButtons.forEach(button => {
      button.addEventListener('click', () => {
        const targetTab = button.getAttribute('data-tab')

        // Update button states
        freshTabButtons.forEach(btn => {
          if (btn.getAttribute('data-tab') === targetTab) {
            btn.classList.remove('border-transparent', 'text-subtle')
            btn.classList.add('border-[var(--color-brand-primary)]', 'text-[var(--color-brand-primary)]')
          } else {
            btn.classList.remove('border-[var(--color-brand-primary)]', 'text-[var(--color-brand-primary)]')
            btn.classList.add('border-transparent', 'text-subtle')
          }
        })

        // Update content visibility
        tabContents.forEach(content => {
          if (content.getAttribute('data-tab-content') === targetTab) {
            content.classList.remove('hidden')
          } else {
            content.classList.add('hidden')
          }
        })
      })
    })
  }
}

