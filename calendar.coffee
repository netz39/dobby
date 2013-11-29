ical = require('ical')
should = require('should')
util = require('util')

class CalendarEvent
	constructor : (name, start, end=null, description="") ->
		@name = name
		@start = start
		@name.should.be.ok
		@start.should.be.a.Date
		@end = end
		@description = description
	toString : () ->
		str = @start.toLocaleString()
		str = str + @end.toLocaleString() if end?
		str = str + " : " + @name + "\n"
		str = str + @description

class Calendar
	constructor : (ical_url) ->
		@ical_url = ical_url
		@events = []
		@fetch_events(@events)

	fetch_events : (events) ->
		ical.fromURL @ical_url , {} , (err, data) ->
			(events.push(new CalendarEvent(event.summary, event.start, event.end, event.description)) for key, event of data when event.start?)
			events = events.sort (a,b) ->
				return a.start.getTime() - b.start.getTime()

	getNames : () ->
		return (event.name for event in events)

	toString : () ->
		return (event.toString() for event in @events).join("\n\n")

exports.Calendar = Calendar
exports.CalendarEvent = CalendarEvent
