randomInt = (x) ->
  Math.floor(Math.random() * x)

randomCellIndicies = ->
  [randomInt(4), randomInt(4)]

randomValue = ->
  values = [2,2,2,4]
  values[randomInt(4)]

buildBoard = ->
  [0..3].map -> [0..3].map -> 0

# buildBoardSlow = ->
#   board = []
#   for row in [0..3]
#     board[row] = []
#     for col in [0..3]
#       board[row][col] = 0
#   board

generateTile = (board) ->
  value = randomValue()
  console.log "randomInt: #{randomCellIndicies()}"
  [row, column] = randomCellIndicies()
  if board[row][column] is 0
    board[row][column] = value
  else
    generateTile(board)
  console.log ("Generate tile!")

printArray = (array) ->
  console.log "--- Start ---"
  for row in array
    console.log row
  console.log "--- End ---"



$ ->
  newBoard = buildBoard()
  generateTile(newBoard)
  generateTile(newBoard)
  printArray(newBoard)
