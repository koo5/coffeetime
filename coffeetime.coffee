#!/usr/bin/env coffee
path = require 'path'
fs = require 'fs'
os = require 'os'
paths={}
paths.home = process.env['HOME'] + "/.coffeetime"
paths.time = paths.home + "/time.json"
console.log paths.time + " exists: " + path.existsSync paths.time

load = () ->
    if path.existsSync paths.time
        JSON.parse fs.readFileSync paths.time

save =()->
    if not path.existsSync paths.home
        fs.mkdirSync paths.home, 0700
    fs.writeFileSync paths.time, JSON.stringify time
    console.log "written"

addparam = (o,param)->
    unless param of o
        o[param] = 0
    o

addclock = (o)->
    o = addparam o, 'hours'
    o = addparam o, 'minutes'
    o = addparam o, 'seconds'

time = load() || {}    
time = addclock time
save()
console.log time
session = addclock {}
timer = null

overflow = (time)->
    if time.seconds > 59
        time.seconds -= 60
        time.minutes++
    if time.minutes > 59
        time.minutes -= 60
        time.hours++
    time

togglerunning =()->
    if timer
        clearInterval timer
        timer = null
        console.log "stopped"
    else
        timer = setInterval ()->
            time.seconds++
            session.seconds++
            time = overflow time
            session = overflow session
            human = session.hours + ":" + session.minutes + ":" + session.seconds
            console.log human + "\33]0;" + human + "\7"
            if (time.seconds == 0) and (time.minutes % 10 == 0) then save()
        , 1000
        console.log "running"

togglerunning()
process.stdin.resume();
process.stdin.on 'data', (data) ->
    togglerunning()
    
process.on 'SIGINT' ,()->
    console.log "saving"
    save()
    process.exit()