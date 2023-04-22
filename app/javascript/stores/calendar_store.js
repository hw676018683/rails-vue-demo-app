import { defineStore } from 'pinia'

export const CalendarStore = defineStore('calendars', {
  state: () => {
    return {
      calendars: [],
      partners: []
    }
  },

  actions: {
    async index(date) {
      return this.axios.get(`/calendars?date=${date}`).then(response => {
        this.calendars = response.data.calendars;
        this.partners = response.data.partners;
      })
    }
  },
})
