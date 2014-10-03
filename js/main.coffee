randomInt = (x) ->
  Math.floor(Math.random() * x)

randomCellIndicies = ->
  [randomInt(4), randomInt(4)]

randomValue = ->
  values = [2,2,2,4]
  values[randomInt(4)]

buildBoard = ->
  [0..3].map -> [0..3].map -> 0

generateTile = (board) ->
  value = randomValue()
  [row, column] = randomCellIndicies()
  if board[row][column] is 0
    board[row][column] = value
  else
    generateTile(board)

move = (board, direction) ->
  newBoard = buildBoard()
  for i in [0..3]
    if direction is 'right' or direction is 'left'
      row = getRow(i, board)
      row = mergeCells(row, direction)
      row = collapseCells(row, direction)
      setRow(row, i, newBoard)
    else if direction is 'up' or direction is 'down'
      column = getCol(i, board)
      column = mergeCells(column, direction)
      column = collapseCells(column, direction)
      setCol(column, i, newBoard)

  newBoard

getRow = (r, board) ->
  [board[r][0], board[r][1], board[r][2], board[r][3]]

setRow = (row, index, board) ->
  board[index] = row

getCol = (c, board) ->
  [board[0][c], board[1][c],board[2][c], board[3][c]]

setCol = (col, index, board) ->
  for i in [0..3]
    board[i][index] = col[i]

mergeCells = (cell, direction) ->

  merge = (cell) ->
    for a in [3...0]
      for b in [a-1..0]

        if cell[a] is 0 then break
        else if cell[a] == cell[b]
          cell[a] *= 2
          cell[b] = 0
          break
        else if cell[b] isnt 0 then break
    cell

  if direction is 'right' or direction is 'down'
    merge cell
  else if direction is 'left' or direction is 'up'
    merge(cell.reverse()).reverse()

collapseCells = (cell, direction) ->
  cell = cell.filter (ele) -> ele isnt 0
  while cell.length < 4
    if direction is 'right' or direction is 'down'
      cell.unshift 0
    else if direction is 'left' or direction is 'up'
      cell.push 0
  cell

moveIsValid = (originalBoard, newBoard) ->
  for row in [0..3]
    for col in [0..3]
      if originalBoard[row][col] isnt newBoard[row][col]
        return true
  false

boardIsFull = (board) ->
  for row in board
    if 0 in row
      return false
  true

noValidMove = (board) ->
  newBoard = move(board, direction)
  if moveIsValid(board, newBoard)
    return false
  true

isGameOver = (board) ->
  boardIsFull(board) and noValidMove(board)

showBoard = (board) ->
  for row in [0..3]
    for col in [0..3]
      if board[row][col] is 0
        $(".r#{row}.c#{col} > div").html("")
      else
        $(".r#{row}.c#{col} > div").html(board[row][col])

printArray = (array) ->
  console.log "--- Start ---"
  for row in array
    console.log row
  console.log "--- End ---"


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
      newBoard = move(@board, direction)
      printArray newBoard
      # check the move validity, by comparing the original and new board
      if moveIsValid(@board, newBoard)
        console.log "Valid"
        @board = newBoard
        # generate tile
        generateTile(@board)
        showBoard(@board)
        #check game lost
        if isGameOver(@board)
          console.log "YOU LOSE"
        else
          # show board
          showBoard(@board)
      else
        console.log "Invalid"


      # check move validity, by comparing the original and new board
























