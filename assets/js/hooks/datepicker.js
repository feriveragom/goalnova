/**
 * Datepicker Hook
 * 
 * Calendario visual para selección de fechas.
 * Muestra formato dd/mm/yy al usuario, almacena ISO (yyyy-mm-dd) para el servidor.
 * 
 * Estructura HTML esperada:
 * <div phx-hook="Datepicker" id="datepicker-wrapper">
 *   <input type="hidden" data-value-input name="field_name" value="..." />
 *   <input type="text" data-display-input readonly ... />
 *   <button data-toggle-button>...</button>
 *   <div data-calendar class="hidden">
 *     <!-- Calendar will be rendered here by JS -->
 *   </div>
 * </div>
 */
export const Datepicker = {
  mounted() {
    this.valueInput = this.el.querySelector('[data-value-input]')
    this.displayInput = this.el.querySelector('[data-display-input]')
    this.toggleButton = this.el.querySelector('[data-toggle-button]')
    this.calendar = this.el.querySelector('[data-calendar]')
    
    // Check if readonly mode
    this.checkReadonly()
    
    this.isOpen = false
    this.currentDate = new Date()
    this.selectedDate = null
    this.lastSelectedValue = null // Track last value we set to prevent unnecessary updates
    this.isSelecting = false // Flag to prevent updates during selection
    this.restoreTimeout = null // Timeout for restoring lost values
    
    // Days and months in Spanish
    this.dayNames = ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sá', 'Do']
    this.monthNames = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ]
    
    this.init()
  },

  checkReadonly() {
    this.isReadonly = this.el.dataset.readonly === 'true'
  },

  init() {
    // Parse initial value
    if (this.valueInput.value) {
      this.selectedDate = this.parseIsoDate(this.valueInput.value)
      if (this.selectedDate) {
        this.currentDate = new Date(this.selectedDate)
        this.lastSelectedValue = this.valueInput.value // Track initial value
        this.updateDisplay()
      }
    } else {
      this.lastSelectedValue = ''
    }
    
    // Toggle button click
    if (this.toggleButton) {
      this.toggleButton.addEventListener('click', (e) => {
        e.preventDefault()
        if (!this.isReadonly) {
          this.toggle()
        }
      })
    }
    
    // Display input click (also opens calendar)
    this.displayInput.addEventListener('click', () => {
      if (!this.isReadonly) {
        this.open()
      }
    })
    
    // Close on click outside
    document.addEventListener('click', (e) => {
      if (!this.el.contains(e.target)) {
        this.close()
      }
    })
    
    // Keyboard navigation
    this.el.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        this.close()
      }
    })
  },

  toggle() {
    this.isOpen ? this.close() : this.open()
  },

  open() {
    if (this.isOpen || this.isReadonly) return
    this.isOpen = true
    this.renderCalendar()
    this.calendar.classList.remove('hidden')
  },

  close() {
    this.isOpen = false
    this.calendar.classList.add('hidden')
  },

  renderCalendar() {
    const year = this.currentDate.getFullYear()
    const month = this.currentDate.getMonth()
    
    const html = `
      <div class="p-3 bg-white rounded-lg shadow-lg border border-gray-200 w-[280px]">
        <!-- Header -->
        <div class="flex items-center justify-between mb-3">
          <button type="button" data-prev-month class="p-1 hover:bg-gray-100 rounded">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
            </svg>
          </button>
          <span class="font-semibold text-gray-900">${this.monthNames[month]} ${year}</span>
          <button type="button" data-next-month class="p-1 hover:bg-gray-100 rounded">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </button>
        </div>
        
        <!-- Day names -->
        <div class="grid grid-cols-7 gap-1 mb-1">
          ${this.dayNames.map(d => `<div class="text-center text-xs font-medium text-gray-500 py-1">${d}</div>`).join('')}
        </div>
        
        <!-- Days grid -->
        <div class="grid grid-cols-7 gap-1">
          ${this.renderDays(year, month)}
        </div>
        
        <!-- Today button -->
        <div class="mt-3 pt-3 border-t">
          <button type="button" data-today class="w-full text-sm text-primary-600 hover:text-primary-700 font-medium py-1">
            Hoy
          </button>
        </div>
      </div>
    `
    
    this.calendar.innerHTML = html
    
    // Attach event listeners
    this.calendar.querySelector('[data-prev-month]').addEventListener('click', (e) => {
      e.preventDefault()
      this.prevMonth()
    })
    
    this.calendar.querySelector('[data-next-month]').addEventListener('click', (e) => {
      e.preventDefault()
      this.nextMonth()
    })
    
    this.calendar.querySelector('[data-today]').addEventListener('click', (e) => {
      e.preventDefault()
      this.selectDate(new Date())
    })
    
    this.calendar.querySelectorAll('[data-day]').forEach(el => {
      el.addEventListener('click', (e) => {
        e.preventDefault()
        const date = new Date(parseInt(el.dataset.day))
        this.selectDate(date)
      })
    })
  },

  renderDays(year, month) {
    const firstDay = new Date(year, month, 1)
    const lastDay = new Date(year, month + 1, 0)
    const daysInMonth = lastDay.getDate()
    
    // Get day of week for first day (0 = Sunday, convert to Monday-based)
    let startDay = firstDay.getDay() - 1
    if (startDay < 0) startDay = 6
    
    const today = new Date()
    today.setHours(0, 0, 0, 0)
    
    let html = ''
    
    // Empty cells for days before start
    for (let i = 0; i < startDay; i++) {
      html += '<div class="py-1"></div>'
    }
    
    // Days of the month
    for (let day = 1; day <= daysInMonth; day++) {
      const date = new Date(year, month, day)
      const isToday = date.getTime() === today.getTime()
      const isSelected = this.selectedDate && 
        date.getFullYear() === this.selectedDate.getFullYear() &&
        date.getMonth() === this.selectedDate.getMonth() &&
        date.getDate() === this.selectedDate.getDate()
      
      let classes = 'w-8 h-8 flex items-center justify-center text-sm rounded-full cursor-pointer'
      
      if (isSelected) {
        classes += ' bg-primary-600 text-white font-semibold'
      } else if (isToday) {
        classes += ' bg-primary-100 text-primary-700 font-semibold'
      } else {
        classes += ' hover:bg-gray-100 text-gray-700'
      }
      
      html += `<button type="button" data-day="${date.getTime()}" class="${classes}">${day}</button>`
    }
    
    return html
  },

  prevMonth() {
    this.currentDate.setMonth(this.currentDate.getMonth() - 1)
    this.renderCalendar()
  },

  nextMonth() {
    this.currentDate.setMonth(this.currentDate.getMonth() + 1)
    this.renderCalendar()
  },

  selectDate(date) {
    // Set flag to prevent updates during selection
    this.isSelecting = true
    
    this.selectedDate = date
    this.currentDate = new Date(date)
    
    // Update hidden input with ISO format
    const isoDate = this.formatIso(date)
    this.valueInput.value = isoDate
    this.lastSelectedValue = isoDate // Track what we just set
    
    // Update display input with dd/mm/yy format
    this.updateDisplay()
    
    // Close calendar
    this.close()
    
    // Trigger input event for LiveView
    // Use a small delay to ensure the value is set before the event fires
    setTimeout(() => {
      this.valueInput.dispatchEvent(new Event('input', { bubbles: true }))
      // Clear the flag after a short delay to allow LiveView to process
      setTimeout(() => {
        this.isSelecting = false
      }, 100)
    }, 10)
  },

  updateDisplay() {
    if (this.selectedDate) {
      this.displayInput.value = this.formatDisplay(this.selectedDate)
    } else {
      this.displayInput.value = ''
    }
  },

  formatDisplay(date) {
    const day = String(date.getDate()).padStart(2, '0')
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const year = date.getFullYear()
    return `${day}/${month}/${year}`
  },

  formatIso(date) {
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  },

  parseIsoDate(isoString) {
    if (!isoString) return null
    const parts = isoString.split('-')
    if (parts.length !== 3) return null
    const date = new Date(parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2]))
    return isNaN(date.getTime()) ? null : date
  },

  updated() {
    this.checkReadonly()
    
    // Don't update if we're in the middle of selecting a date
    // This prevents race conditions when LiveView updates during selection
    if (this.isSelecting) {
      return
    }
    
    // Re-sync if value changed externally
    const currentValue = this.valueInput.value || ''
    const currentIso = this.selectedDate ? this.formatIso(this.selectedDate) : ''
    
    // Skip update if this is the value we just set (prevents loop)
    if (currentValue === this.lastSelectedValue) {
      return
    }
    
    // If the value matches what we have, sync lastSelectedValue and return
    if (currentValue === currentIso && currentValue !== '') {
      this.lastSelectedValue = currentValue
      return
    }
    
    // Only sync if the value actually changed externally
    if (currentValue) {
      const newDate = this.parseIsoDate(currentValue)
      if (newDate) {
        // Only update if it's actually different
        if (!this.selectedDate || newDate.getTime() !== this.selectedDate.getTime()) {
          this.selectedDate = newDate
          this.currentDate = new Date(newDate)
          this.lastSelectedValue = currentValue
          this.updateDisplay()
        }
      }
    } else {
      // If input is empty, check if we have a selected date that should be preserved
      if (this.selectedDate && this.lastSelectedValue && this.lastSelectedValue !== '') {
        // Server returned empty value but we have a selected date
        // This happens when the server doesn't include the field in the changeset
        // Restore the value immediately to prevent it from being lost
        const isoDate = this.formatIso(this.selectedDate)
        
        // Only restore if the input is actually empty (not just whitespace)
        if (!this.valueInput.value || this.valueInput.value.trim() === '') {
          this.valueInput.value = isoDate
          this.lastSelectedValue = isoDate
          this.updateDisplay()
          
          // Use a debounced event to avoid loops - only fire if value is still correct after delay
          if (this.restoreTimeout) {
            clearTimeout(this.restoreTimeout)
          }
          
          this.restoreTimeout = setTimeout(() => {
            // Double-check that we still need to sync
            if (this.valueInput.value === isoDate && this.selectedDate) {
              // Trigger input event to sync with LiveView
              this.valueInput.dispatchEvent(new Event('input', { bubbles: true }))
            }
            this.restoreTimeout = null
          }, 150) // Small delay to batch updates
        }
      } else if (!this.lastSelectedValue || this.lastSelectedValue === '') {
        // Form was reset from empty state, clear everything
        if (this.restoreTimeout) {
          clearTimeout(this.restoreTimeout)
          this.restoreTimeout = null
        }
        this.selectedDate = null
        this.updateDisplay()
      }
    }
  }
}

