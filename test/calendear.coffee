calendar = require('../calendar.coffee')
timers = require('timers')
util = require('util')
moment = require('moment')
moment().format()

describe 'calendar.coffee', ->
	describe 'Calendar', ->
		cal = new calendar.Calendar(process.env.DOBBY_ICAL_URL, [])
		it 'should be able to fetch ical entrys', (done) ->
			test = () ->
				cal.entrys.should.not.be.empty
				done()
			timers.setTimeout(test, 1500)
		it 'should display the raw data from remote ical', (done) ->
			test = () ->
				cal.raw.should.not.be.empty
				done()
			timers.setTimeout(test, 1500)

		cal2 = new calendar.Calendar()
		it 'should implement an addEvent-Method', ->
			cal2.addEvent(new calendar.CalendarEvent('Foo', new Date()))
			cal2.getNames().should.contain('Foo')
		it 'should display all events in a certian timerange', ->
			now = moment()
			i = 1
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.add('days', 7)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.add('days', 1)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.add('hours', 1)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.add('months', 1)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.add('months', 11)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.add('years', 1)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.add('weeks', 2)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.add('seconds', 7)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.subtract('days', 7)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.subtract('days', 1)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.subtract('hours', 1)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.subtract('months', 1)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.subtract('months', 11)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.subtract('years', 1)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.subtract('weeks', 2)))
			cal2.addEvent(new calendar.CalendarEvent("Foo#{i++}", now.subtract('seconds', 7)))

			test = (start, end) ->
				r1 = cal2.getRange start, end
				for entry in r1
					start.isBefore(entry.start).should.be.ok
					end.isAfter(entry.start).should.be.ok
			test moment(), moment().add('months', 1)
			test moment(), moment().subtract('months', 1)
			test moment().add('months', 1), moment().subtract('weeks', 3)



			
	describe 'CalendarEvent', ->
		d = new Date()
		e = new calendar.CalendarEvent("foobar", d)
		it 'should implement start, name, description and summary', ->
			e.start.isSame(d).should.be.true
			e.name.should.equal "foobar"
		it 'should implement a unique identifier', ->
			e.uuid.should.exist
