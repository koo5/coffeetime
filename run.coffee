#!/usr/bin/env coffee
c = require "./coffeetime.coffee"

process.on 'SIGINT',
()->
    console.log ''
    c.sigint()
    console.log c
    process.exit()

console.log c

c.init()

