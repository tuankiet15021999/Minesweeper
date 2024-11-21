class BoardsController < ApplicationController
  def index
    @boards = Board.all.order(created_at: :desc).page(params[:page]).per(15)
    render :index
  end

  def show
    @board = Board.find_by(id: params[:id])
    if @board
      @data = generate_two_dimensional_array(@board)
      render :show
    else
      redirect_to boards_url
    end
  end

  def new
    @board = Board.new
    @User = User.new
  end

  def create
    @user = User.find_or_create_by(email: board_params[:email])
    if @user
      @board = @user.boards.new(board_params.except(:email))
      if @board.save
        redirect_to board_url(@board)
      else
        render :new
      end
    end
  end

  def top_boards
    @boards = Board.all.order(created_at: :desc).limit(10)
    render :home
  end
  private

  def board_params
    params.required(:board).permit(:email, :name, :width, :height, :num_of_mines)
  end

  def generate_two_dimensional_array(board)
    init_two_dimensional_array = Array.new(board.height) { Array.new(board.width, false) }
    mines = board.mines
    mines.each do |mine|
      init_two_dimensional_array[mine.y][mine.x] = true
    end

    header_row = [""] + (1..board.width).to_a

    result = init_two_dimensional_array.map.with_index do |row, index|
      [index + 1] + row
    end
    result.unshift(header_row)
    return result
  end
end
