require! {
  leshdash: { head, waitCancel, clone, reduce, map }
  midi
}

input = new midi.input();

lastPress = void
lastSpace = void
eraseMessage = false

eventTimings = []
spaceTimings = []

input.on 'message', (deltaTime, message) ->
  console.log message,
  console.log eventTimings
  console.log spaceTimings
  console.log "------------------------"
  switch head message
    | 128 =>
      if lastPress then addPress(Date.now! - lastPress)
      lastSpace := Date.now!
    | 144 =>
      if lastSpace then addSpace(Date.now! - lastSpace)
      lastPress := Date.now!

  if eraseMessage then eraseMessage()

  eraseMessage := waitCancel ((getMedian(spaceTimings) * 3) or 1000), ->
    interpretMessage parseMessage eventTimings
    eventTimings := []
    spaceTimings := []

input.openVirtualPort("Monitor Input")

addPress = -> eventTimings.push it
addSpace = -> spaceTimings.push it

getMedian = (list) -> reduce(list, (+), 0) / list.length

parseMessage = (timings) ->
  median = getMedian(timings)
  map(timings, -> if it > median then "_" else ".").join("")

interpretMessage = (message) ->
  switch message
    | "_..._" => console.log "UNLOCK"
    |_ => console.log "FAIL"
