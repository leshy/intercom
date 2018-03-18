require! { midi }

input = new midi.input();

input.on 'message', (deltaTime, message)  -> 
    console.log('m:' + message + ' d:' + deltaTime)

input.openVirtualPort("Monitor Input")


# output = new midi.output()
# output.openVirtualPort("Test Output")
# setInterval do
#   -> output.sendMessage [144,22,127]
#   1000
  


