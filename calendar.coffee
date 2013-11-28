ical = require('ical')
should = require('should')

class CalendarEvent
	constructor : (name, start, end=null, summary="", description="") ->
		@name = name
		@start = start
		@name.should.be.ok
		@start.should.be.a.Date
		@end = end
		@summary = summary
		@description = description
	

class Calendar
	constructor : (ical_url) ->
		@ical_url = ical_url
		@fetch_events()

	fetch_events : () ->
		@events = ["dummy"]
		ical.fromURL @ical_url , {} , (err, data) ->
			(@events.push(event) for key, event of data when event.start?)
	
exports.Calendar = Calendar
exports.CalendarEvent = CalendarEvent
