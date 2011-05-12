class flipflop
    constructor: (props) ->
	this.bit = props.bit
	this.on_on = props.on_on
	this.on_off = props.on_off
	
    toggle: () ->
        this.bit = not this.bit
        this.fire()
        
    fire: () ->
        if this.bit
            this.on_on()
        else
            this.on_off()

    wake_up: () ->
        this.fire()
        
exports.flipflop = flipflop

class timer
    stop()->
	clearInterval t
    start(int)->
	setInterval on_tick, int
