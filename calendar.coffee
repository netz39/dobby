ical = require('ical')
should = require('should')
util = require('util')
moment = require('moment')
moment().format()
gen_uuid = require('node-uuid').v4
RRule = require('rrule').RRule

class CalendarEvent
	constructor : (@name="fu!", start, end=null, @description="", @uuid=gen_uuid()) ->
		@start = moment(start)
		@name.should.be.ok
		@start.should.be.a.Date
		@end = moment(end) if end?

	toString : () ->
		str = @start.toLocaleString()
		str = str + @end.toLocaleString() if end?
		str = str + " : " + @name + "\n"
		str = str + @description

addReoccuringEvent = (event, events) ->
	dates = []
	event.rrule.origOptions.dtstart = event.start
	event.rrule = event.rrule.clone()
	dates = event.rrule.between(moment().toDate(), moment().add('years', 1).toDate())
	util.puts event.rrule.toText()
	util.puts event.rrule.toString()
	util.puts event.start
	util.puts util.inspect(dates)
	for i,d of dates
		events.push new CalendarEvent(event.summary, d, null, event.description)
	events = events.sort (a,b) ->
		return a.start.diff(b.start)


fetch_entrys = (ical_url, opts, events, raw, cb) ->
		util.puts "fetching entries from #{ical_url}"
		ical.fromURL ical_url , opts , (err, data) ->
			util.puts "ok" if data?
			raw.push util.inspect(data, { depth : 5 })
			util.puts err if err?
			for key, event of data when event.start? and event.summary?
				if event.rrule?
					addReoccuringEvent(event, events)
				else
					events.push(new CalendarEvent(event.summary, event.start, event.end, event.description))
			events = events.sort (a,b) ->
				return a.start.diff(b.start)
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
			return a.start.diff(b.start)

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
		_result = _result.sort (a,b) ->
			return a.start.diff(b.start)
		return _result


exports.Calendar = Calendar
exports.CalendarEvent = CalendarEvent
