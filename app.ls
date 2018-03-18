require! {
  midi
  leshdash: { head, waitCancel, clone, reduce, map }
}

input = new midi.input();

lastPress = 0
eraseMessage = false
eventTimigs = []

input.on 'message', (deltaTime, message) ->
  switch head message
    | 128 => addPress(Date.now! - lastPress)
    | 144 => lastPress := Date.now!

  if eraseMessage then eraseMessage()
    
  eraseMessage := waitCancel 1000, ->
    interpretMessage parseMessage eventTimigs
    eventTimigs := []

input.openVirtualPort("Monitor Input")

addPress = -> eventTimigs.push it

parseMessage = (timings) ->
  middle = reduce(timings, (+), 0) / timings.length
  map(timings, -> if it > middle then "_" else ".").join("")

interpretMessage = (message) ->
  console.log message
  switch message
    | "_..._" => console.log "UNLOCK"
    |_ => console.log "FAIL"
