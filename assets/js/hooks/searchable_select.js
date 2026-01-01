/**
 * SearchableSelect Hook
 * 
 * Transforma un select nativo en un componente con búsqueda/filtrado.
 * 
 * Estructura HTML esperada:
 * <div phx-hook="SearchableSelect" id="select-wrapper" data-name="field_name">
 *   <input type="hidden" data-value-input name="field_name" value="..." />
 *   <button data-toggle-button>
 *     <span data-display-text>Seleccione...</span>
 *     <svg data-chevron>...</svg>
 *   </button>
 *   <div data-dropdown class="hidden">
 *     <input data-search-input placeholder="Buscar..." />
 *     <ul data-options-list>
 *       <li data-option data-value="1">Opción 1</li>
 *       <li data-option data-value="2">Opción 2</li>
 *     </ul>
 *   </div>
 * </div>
 */
export const SearchableSelect = {
  mounted() {
    this.valueInput = this.el.querySelector('[data-value-input]')
    this.toggleButton = this.el.querySelector('[data-toggle-button]')
    this.displayText = this.el.querySelector('[data-display-text]')
    this.dropdown = this.el.querySelector('[data-dropdown]')
    this.searchInput = this.el.querySelector('[data-search-input]')
    this.optionsList = this.el.querySelector('[data-options-list]')
    this.chevron = this.el.querySelector('[data-chevron]')
    
    this.isOpen = false
    this.options = []
    this.filteredOptions = []
    this.highlightedIndex = -1
    
    this.init()
  },

  init() {
    // Collect all options
    this.collectOptions()
    
    // Set initial display text
    this.updateDisplayText()
    
    // Event listeners
    this.toggleButton.addEventListener('click', (e) => {
      e.preventDefault()
      this.toggle()
    })
    
    this.searchInput.addEventListener('input', (e) => {
      this.filter(e.target.value)
    })
    
    this.searchInput.addEventListener('keydown', (e) => {
      this.handleKeydown(e)
    })
    
    // Click outside to close
    document.addEventListener('click', (e) => {
      if (!this.el.contains(e.target)) {
        this.close()
      }
    })
    
    // Option click
    this.optionsList.addEventListener('click', (e) => {
      const option = e.target.closest('[data-option]')
      if (option) {
        this.selectOption(option.dataset.value, option.textContent.trim())
      }
    })
  },

  collectOptions() {
    const optionElements = this.optionsList.querySelectorAll('[data-option]')
    this.options = Array.from(optionElements).map(el => ({
      value: el.dataset.value,
      label: el.textContent.trim(),
      element: el
    }))
    this.filteredOptions = [...this.options]
  },

  toggle() {
    this.isOpen ? this.close() : this.open()
  },

  open() {
    this.isOpen = true
    this.dropdown.classList.remove('hidden')
    this.chevron?.classList.add('rotate-180')
    this.searchInput.value = ''
    this.filter('')
    this.searchInput.focus()
    this.highlightedIndex = -1
  },

  close() {
    this.isOpen = false
    this.dropdown.classList.add('hidden')
    this.chevron?.classList.remove('rotate-180')
    this.highlightedIndex = -1
  },

  filter(query) {
    const lowerQuery = query.toLowerCase()
    
    this.options.forEach(opt => {
      const matches = opt.label.toLowerCase().includes(lowerQuery)
      opt.element.classList.toggle('hidden', !matches)
    })
    
    this.filteredOptions = this.options.filter(opt => 
      opt.label.toLowerCase().includes(lowerQuery)
    )
    
    this.highlightedIndex = this.filteredOptions.length > 0 ? 0 : -1
    this.updateHighlight()
  },

  handleKeydown(e) {
    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault()
        this.highlightedIndex = Math.min(
          this.highlightedIndex + 1, 
          this.filteredOptions.length - 1
        )
        this.updateHighlight()
        break
      case 'ArrowUp':
        e.preventDefault()
        this.highlightedIndex = Math.max(this.highlightedIndex - 1, 0)
        this.updateHighlight()
        break
      case 'Enter':
        e.preventDefault()
        if (this.highlightedIndex >= 0 && this.filteredOptions[this.highlightedIndex]) {
          const opt = this.filteredOptions[this.highlightedIndex]
          this.selectOption(opt.value, opt.label)
        }
        break
      case 'Escape':
        e.preventDefault()
        this.close()
        this.toggleButton.focus()
        break
    }
  },

  updateHighlight() {
    // Remove highlight from all
    this.options.forEach(opt => {
      opt.element.classList.remove('bg-primary-100', 'text-primary-900')
    })
    
    // Add highlight to current
    if (this.highlightedIndex >= 0 && this.filteredOptions[this.highlightedIndex]) {
      const opt = this.filteredOptions[this.highlightedIndex]
      opt.element.classList.add('bg-primary-100', 'text-primary-900')
      opt.element.scrollIntoView({ block: 'nearest' })
    }
  },

  selectOption(value, label) {
    this.valueInput.value = value
    this.displayText.textContent = label
    this.close()
    
    // Trigger input event for LiveView
    this.valueInput.dispatchEvent(new Event('input', { bubbles: true }))
  },

  updateDisplayText() {
    const currentValue = this.valueInput.value
    const option = this.options.find(opt => opt.value === currentValue)
    
    if (option) {
      this.displayText.textContent = option.label
    }
  },

  updated() {
    // Re-collect options if DOM changed
    this.collectOptions()
    this.updateDisplayText()
  }
}

