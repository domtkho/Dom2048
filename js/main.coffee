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
  [row, column] = randomCellIndicies()
  if board[row][column] is 0
    board[row][column] = value
  else
    generateTile(board)

showBoard = (board) ->
  for row in [0..3]
    for col in [0..3]
      $(".r#{row}.c#{col} > div").html(board[row][col])

printArray = (array) ->
  console.log "--- Start ---"
  for row in array
    console.log row
  console.log "--- End ---"


move = (board, direction) ->
  for i in [0..3]
    if direction == 'right' or  'left'
      row = getRow(i, board)
      row = mergeCells(row, direction)
      row = collapseCells(row, direction)
      console.log row

getRow = (r, board) ->
  [board[r][0], board[r][1], board[r][2], board[r][3]]

mergeCells = (row, direction) ->

  if direction is 'right'
    for a in [3...0]
      for b in [a-1..0]

        if row[a] is 0 then break
        else if row[a] == row[b]
          row[a] *= 2
          row[b] = 0
          break
        else if row[b] isnt 0 then break
  row

console.log mergeCells [4,4,4,4], 'right'

collapseCells = (row, direction) ->
  row = row.filter (ele) -> ele isnt 0
  if direction is 'right'
    while row.length < 4
      row.unshift 0
  else if direction is 'left'
    while row.length < 4
      row.push 0
  row

console.log collapseCells [0,4,4,0], 'right'



$ ->
  @board = buildBoard()
  generateTile(@board)
  generateTile(@board)
  printArray(@board)
  showBoard(@board)

  $('body').keydown (e) =>
    key = e.which
    keys = [37..40]

    if key in keys
      e.preventDefault()
      direction = switch key
        when 37 then 'left'
        when 38 then 'up'
        when 39 then 'right'
        when 40 then 'down'
      console.log direction

      # try moving
      move(@board, direction)
      # check move validity






















