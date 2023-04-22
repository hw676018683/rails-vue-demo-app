<template>
	<section class="container">
		<h1>Live Calendar</h1>

		<table class="table">
			<thead>
				<tr>
					<th scope="col">时间</th>
				<th v-for="partner in store.partners" :key="partner.id">
					{{ partner.name }}
				</th>
				</tr>
			</thead>
			<tbody>
				<tr v-for="calendar in store.calendars" :key="calendar.time">
					<th scope="row">{{ calendar.time }}</th>
					<td v-for="partner in store.partners" :key="partner.id" :set="meeting = calendar.meetings.find(meeting => meeting.partner_id == partner.id)">
						{{ meeting ? meeting.candidate_name : "" }}
					</td>
				</tr>
			</tbody>
		</table>

	</section>
</template>

<script>
import { CalendarStore } from "@/stores/calendar_store";

export default {
	setup() {
		const store = CalendarStore();

		return { store };
	},

	created() {
		this.$api.call(this.store.index("2023-04-22"));
	},
};
</script>
