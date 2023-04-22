<template>
	<section class="container">
		<h1>Live Calendar</h1>

		<ul class="breadcrumb">
      		<li><span>{{ date }}</span></li>
    	</ul>

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
						{{ meetingText(meeting) }}
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

		const params = new Proxy(new URLSearchParams(window.location.search), {
			get: (searchParams, prop) => searchParams.get(prop),
		});

		return { store: store, date: params.date };
	},

	created() {
		this.$api.call(this.store.index(this.date));

		this.$cable.on('chat', (event) => {
			this.$api.call(this.store.index(this.date));
    	})
	},

	methods: {
		meetingText(meeting) {
			if (meeting) {
				return meeting.status == 0 ? meeting.id + meeting.candidate_name : "已取消"
			} else {
				return "空闲"
			}
		}
	}
};
</script>
