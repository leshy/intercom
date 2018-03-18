require! {
  ribcage
  onoff: { Gpio }
  statemachine: { StateMachine }
  leshdash: { w, wait }
}

class Gpio
  (@pin) -> true
  
  writeSync: (@val) ->
    console.log "WRITE", @pin, @val
    
  readSync: ->
    console.log "READ", @pin, @val
    @val


ribcage.init { settings: { verboseinit: true } }, (err, env) ->
  
  env.log("initialized")
  
  Door = StateMachine.extend4000 do
    (pin) ->
      @pin = new Gpio pin, 'out'
      @pin.writeSync 1 # off
      
    open: w.cooldown 10000,  ->
      env.log "buzz in start"
      @pin.writeSync 0
      wait 1000, ~>
        env.log "buzz in stop"

        @pin.writeSync 1
        
  
  bell = new Gpio(17, 'in')
  door = new Door 18

  setInterval (-> door.open()), 1000
#  door.writeSync 1 # off 




  # check = ->
  #   # seems like read() was floating around
  #   val = Boolean bell.readSync()

  #   if val then door.writeSync 1
  #   else door.writeSync 0




  # setInterval check, 100
