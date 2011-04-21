#!/usr/bin/env coffee
c = require "./coffeetime.coffee"

process.on 'SIGINT',
()->
    console.log ''
    c.sigint()
    console.log c.time
    process.exit()

c.init()

