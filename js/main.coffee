@score = 0
@moves = 0

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
    animateTileGeneration(row, column)
  else
    generateTile(board)

move = (board, direction) =>
  newBoard = buildBoard()
  for i in [0..3]
    if direction in ['right', 'left']
      row = getRow(i, board)
      row = mergeCells(row, direction)
      row = collapseCells(row, direction)
      setRow(row, i, newBoard)
    else if direction in ['up', 'down']
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

mergeCells = (cells, direction) =>

  merge = (cells) ->
    for a in [3...0]
      for b in [a-1..0]

        if cells[a] is 0 then break
        else if cells[a] == cells[b]
          cells[a] *= 2
          cells[b] = 0
          updateScore(@score += cells[a])
          break
        else if cells[b] isnt 0 then break
    cells

  if direction in ['right', 'down']
    merge cells
  else if direction in ['left', 'up']
    merge(cells.reverse()).reverse()


collapseCells = (cell, direction) ->
  cell = cell.filter (ele) -> ele isnt 0
  while cell.length < 4
    if direction in ['right', 'down']
      cell.unshift 0
    else if direction in ['left', 'up']
      cell.push 0
  cell

moveIsValid = (originalBoard, newBoard) ->
  for row in [0..3]
    for col in [0..3]
      if originalBoard[row][col] isnt newBoard[row][col]
        updateMoves(@moves++)
        return true

  false

boardIsFull = (board) ->
  for row in board
    if 0 in row
      return false
  true

noValidMove = (board) ->
  for direction in ['up', 'down', 'left', 'right']
    newBoard = move(board, direction)
    if moveIsValid(board, newBoard)
      return false
  true

isGameOver = (board) ->
  noValidMove(board) and boardIsFull(board)

showBoard = (board) ->
  for row in [0..3]
    for col in [0..3]
      switch board[row][col]
        when 0 then $(".r#{row}.c#{col} > div").html("").css("background", "#6D7D8D")
        when 2 then $(".r#{row}.c#{col} > div").html(board[row][col]).css({background: "#139ACC", color: "#FFFFFF"})
        when 4 then $(".r#{row}.c#{col} > div").html(board[row][col]).css({background: "#FFF54A", color: "#5D5D5D"})
        when 8 then $(".r#{row}.c#{col} > div").html(board[row][col]).css({background: "#FF315E", color: "#FFFFFF"})
        when 16 then $(".r#{row}.c#{col} > div").html(board[row][col]).css({background: "#B28992", color: "#FFFFFF"})
        when 32 then $(".r#{row}.c#{col} > div").html(board[row][col]).css({background: "#D6FFDE", color: "#5D5D5D"})
        when 64 then $(".r#{row}.c#{col} > div").html(board[row][col]).css({background: "#B29F88", color: "#FFFFFF"})
        when 128 then $(".r#{row}.c#{col} > div").html(board[row][col]).css({background: "#CC415D", color: "#FFFFFF"})
        when 256 then $(".r#{row}.c#{col} > div").html(board[row][col]).css({background: "#B2B2A1", color: "#FFFFFF"})
        when 512 then $(".r#{row}.c#{col} > div").html(board[row][col]).css({background: "#FFB324", color: "#5D5D5D"})
        when 1024 then $(".r#{row}.c#{col} > div").html(board[row][col]).css({background: "#3FCC83", color: "#FFFFFF"})
        when 2048 then $(".r#{row}.c#{col} > div").html(board[row][col]).css({background: "#3D2040", color: "#FFFFFF"})
        when 4096 then $(".r#{row}.c#{col} > div").html(board[row][col]).css({background: "#F13D00", color: "#FFFFFF"})
        when 8192 then $(".r#{row}.c#{col} > div").html(board[row][col]).css({background: "#274514", color: "#FFFFFF"})
        when 16384 then $(".r#{row}.c#{col} > div").html(board[row][col]).css({background: "#00135E", color: "#FFFFFF"})

printArray = (array) ->
  console.log "--- Start ---"
  for row in array
    console.log row
  console.log "--- End ---"

resetToZero = ->
  0

updateMoves = ->
  $('h3.moves').html(@moves)

updateScore = ->
  $('h3.score').html(@score)

resetGame = (board) ->
  @moves = resetToZero()
  updateMoves()
  @score = resetToZero()
  updateScore()
  board = buildBoard()

animateTileGeneration = (row, column) ->
  $(".r#{row}.c#{column} > .tile").css({
    position: 'relative', left: '50px', top: '50px', height: '0', width: '0'
  }).animate({
    height: '100%', width: '100%',left: '0', top: '0'}, 150)    # To fix animation


$ ->
  @board = buildBoard()
  generateTile(@board)
  generateTile(@board)
  # printArray(@board)
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
      # console.log direction

      # try moving
      newBoard = move(@board, direction)
      # printArray newBoard
      # check the move validity, by comparing the original and new board
      if moveIsValid(@board, newBoard)
        # console.log "Valid"
        @board = newBoard
        # generate tile
        generateTile(@board)
        showBoard(@board)
        #check game lost
        if isGameOver(@board)
          console.log "Game Over!"
        else
          # show board
          showBoard(@board)

      else
        console.log "Invalid"
      # check move validity, by comparing the original and new board

  $('button.reset').click =>
    @board = resetGame(@board)
    generateTile(@board)
    generateTile(@board)
    showBoard(@board)
























