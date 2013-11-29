calendar = require('../calendar.coffee')
timers = require('timers')

describe 'calendar.coffee', ->
	describe 'Calendar', ->
		it 'should be able to fetch ical entrys', (done) ->
			cal = new calendar.Calendar(process.env.DOBBY_ICAL_URL, [])
			test = () ->
				cal.entrys.should.not.be.empty
				done()
			timers.setTimeout(test, 1500)
		it 'should implement an addEvent-Method', ->
			cal2 = new calendar.Calendar()
			cal2.addEvent(new calendar.CalendarEvent('Foo', new Date()))
			cal2.getNames().should.contain('Foo')
			
	describe 'CalendarEvent', ->
		it 'should implement start, name, description and summary', ->
			d = new Date()
			e = new calendar.CalendarEvent("foobar", d)
			e.start.should.equal d
			e.name.should.equal "foobar"
