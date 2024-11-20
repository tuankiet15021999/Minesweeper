# README

# Todo
  Board form:
    - Email
    - Name
    - Width
    - Height
    - Num of mines
    - Generate board button
    Validate:
      unqiue: email, name
      length > 1: width, height, num_of_mines
  Home:
    - Show top ten most recently generated boards
    - View all generated boards
  Boards:
    - Show all generated boards
    - New Board button
    - Pagination
  Detail Boards:
    - Detail board
    - Minesweeper board

# Docker/docker-compose run
- docker-compose build
- docker-compose up backend

# ENV
DB_HOST=db
DB_PORT=3306
DB_USER=root
DB_PASS=12345678
