ical = require('ical')
should = require('should')
util = require('util')
moment = require('moment')
moment().format()

class CalendarEvent
	constructor : (@name, start, end=null, @description="") ->
		@start = moment(start)
		@name.should.be.ok
		@start.should.be.a.Date
		@end = moment(end) if end?
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
				return a.start.isBefore(b.start)
			cb(events) if cb

class Calendar
	constructor : (@ical_url, @entrys=[], cb) ->
		if @ical_url
			fetch_entrys @ical_url, @entrys, (entrys) ->
				@entrys = entrys
				cb() if cb?

	sortEntrys : () ->
		@entrys = @entrys.sort (a,b) ->
			return a.start.isBefore(b.start)

	addEvent : (entry) ->
		entry.should.be.ok
		@entrys.push(entry)
		@sortEntrys()


	getNames : () ->
		return (entry.name for entry in @entrys)

	toString : () ->
		return (entry.toString() for entry in @entrys).join("\n\n")

	getRange : (start, end) ->
		_result = []
		for entry in @entrys
			if not entry.start?
				util.puts entry
			if entry.start.isAfter(start) and entry.start.isBefore(end)
				_result.push entry
		eturn _result


exports.Calendar = Calendar
exports.CalendarEvent = CalendarEvent
