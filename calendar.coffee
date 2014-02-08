ical = require('ical')
should = require('should')
util = require('util')
moment = require('moment')
moment().format()
gen_uuid = require('node-uuid').v4

class CalendarEvent
	constructor : (@name, start, end=null, @description="", @uuid=gen_uuid()) ->
		@start = moment(start)
		@name.should.be.ok
		@start.should.be.a.Date
		@end = moment(end) if end?

	toString : () ->
		str = @start.toLocaleString()
		str = str + @end.toLocaleString() if end?
		str = str + " : " + @name + "\n"
		str = str + @description

fetch_entrys = (ical_url, opts, events, raw, cb) ->
		util.puts "fetching entries from #{ical_url}"
		util.puts util.inspect(opts)
		ical.fromURL ical_url , opts , (err, data) ->
			util.puts "ok" if data?
			util.puts util.inspect(data)
			raw.push util.inspect(data)
			util.puts err if err?
			(events.push(new CalendarEvent(event.summary, event.start, event.end, event.description)) for key, event of data when event.start?)
			events = events.sort (a,b) ->
				return a.start.isAfter(b.start)
			cb(events, data) if cb?

class Calendar
	constructor : (@ical_url, @ical_user=null, @ical_password="", @entrys=[], cb) ->
		@raw = []
		if @ical_url
			@opts = {}
			if @ical_user
				@opts = {
					'auth' : {
						'user': @ical_user,
						'pass': @ical_password,
						'sendImmediately': true
					}
				}
			fetch_entrys @ical_url, @opts,  @entrys, @raw, (entrys, data) ->
				cb() if cb?

	sortEntrys : () ->
		@entrys = @entrys.sort (a,b) ->
			return a.start.isAfter(b.start)

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
		return _result


exports.Calendar = Calendar
exports.CalendarEvent = CalendarEvent
