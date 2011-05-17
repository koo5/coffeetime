#!/usr/bin/env coffee
path = require 'path'
fs = require 'fs'
os = require 'os'
toys = require './toys'

load = () ->
    try
        JSON.parse fs.readFileSync paths.time
    catch e
        {}

save =()->
    if not path.existsSync paths.home
        fs.mkdirSync paths.home, 0700
    fs.writeFileSync paths.time, JSON.stringify time
    console.log "saved"

addparam = (o,param)->
    unless param of o
        o[param] = 0
    o

addclock = (o)->
    o = addparam o, 'hours'
    o = addparam o, 'minutes'
    o = addparam o, 'seconds'


overflow = (time)->
    if time.seconds > 59
        time.seconds -= 60
        time.minutes++
    if time.minutes > 59
        time.minutes -= 60
        time.hours++
    time

humanize = (time) ->
    return time.hours + ":" + time.minutes

timer = new toys.flipfloptimer
    bit: on
    on_tick: () -> 
        time.seconds++
        session.seconds++
        time = overflow time
        session = overflow session
        human = humanize session
        if (session.seconds == 0)
            if (session.minutes % 10 == 0) then save()
            console.log human + "\33]0;" + human + "\7"
    int: 1000
    on_off: ()->
        console.log "stopped"
    on_on: ()->
        console.log "running, total: " + humanize time
        exports.lasttotal.hours = time.hours
        exports.lasttotal.minutes = time.minutes
        exports.lasttotal.seconds = time.seconds

exports.init = ()->
    paths={}
    paths.home = process.env['HOME'] + "/.coffeetime"
    paths.time = exports.paths.home  + "/time.json"
    time = addclock load()
    console.log time
    save()
    session = addclock {}
    lasttotal = {}
    timer.wake_up()
    process.stdin.resume();
    process.stdin.on 'data', 
        (data)->
            timer.toggle()

exports.sigint = ()->
    save()
