#!/usr/bin/env coffee
path = require 'path'
fs = require 'fs'
os = require 'os'

load = () ->
    try
        JSON.parse fs.readFileSync exports.paths.time
    catch e
        {}

save =()->
    if not path.existsSync exports.paths.home
        fs.mkdirSync exports.paths.home, 0700
    fs.writeFileSync exports.paths.time, JSON.stringify exports.time
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

exports.togglerunning =()->
    if exports.timers.one?
        clearInterval exports.timers.one
        exports.timers.one = null
        console.log "stopped"
    else
        exports.timers.one = setInterval ()->
            exports.time.seconds++
            exports.session.seconds++
            exports.time = overflow exports.time
            exports.session = overflow exports.session
            human = exports.session.hours + ":" + exports.session.minutes + ":" + exports.session.seconds
            console.log human + "\33]0;" + human + "\7"
            if (exports.time.seconds == 0) and (exports.time.minutes % 10 == 0) then exports.save()
        , 1000
        console.log "running"

exports.init = ()->
    exports.paths={}
    exports.timers={}
    exports.paths.home = process.env['HOME'] + "/.coffeetime"
    exports.paths.time = exports.paths.home  + "/time.json"
    exports.time = load()
    exports.time = addclock exports.time
    console.log exports.time
    save()
    exports.session = addclock {}
    exports.togglerunning()
    process.stdin.resume();
    process.stdin.on 'data', 
    (data)->
        exports.togglerunning()

exports.sigint = ()->
    save()