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

fetch_entrys = (ical_url, events, cb) ->
		util.puts "fetching entries from #{ical_url}"
		ical.fromURL ical_url , {} , (err, data) ->
			util.puts err if err?
			(events.push(new CalendarEvent(event.summary, event.start, event.end, event.description)) for key, event of data when event.start?)
			events = events.sort (a,b) ->
				return a.start.getTime() - b.start.getTime()
			cb(events) if cb

class Calendar
	constructor : (@ical_url, @entrys=[], cb) ->
		if @ical_url
			fetch_entrys @ical_url, @entrys, (entrys) ->
				@entrys = entrys
				cb() if cb?

	sortEntrys : () ->
		@entrys = @entrys.sort (a,b) ->
			return a.start.getTime() - b.start.getTime()

	addEvent : (entry) ->
		entry.should.be.ok
		@entrys.push(entry)
		@sortEntrys()


	getNames : () ->
		return (entry.name for entry in @entrys)

	toString : () ->
		return (entry.toString() for entry in @entrys).join("\n\n")

exports.Calendar = Calendar
exports.CalendarEvent = CalendarEvent
