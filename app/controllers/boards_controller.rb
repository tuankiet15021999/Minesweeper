class BoardsController < ApplicationController
  def index
    @boards = Board.all.order(created_at: :desc).page(params[:page]).per(15)
    render :index
  end

  def show
    @board = Board.find_by(id: params[:id])
    
    if @board
      @start_row = params[:start_row].to_i || 0
      @start_col = params[:start_col].to_i || 0
      @action_load = params[:action_load] || "new"
      if @action_load == "loadmore_col"
        @end_row = [@start_row, @board.height].min
        @end_col = [@start_col + 100, @board.width].min
      elsif @action_load == "loadmore_row"
        @end_row = [@start_row + 100, @board.height].min
        @end_col = [@start_col, @board.width].min
      else
        @end_row = [@start_row + 100, @board.height].min
        @end_col = [@start_col + 100, @board.width].min
      end

      @mines_count, @data = generate_two_dimensional_array(@board, @start_row, @start_col, @end_row, @end_col, @action_load)
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

  def generate_two_dimensional_array(board, start_row, start_col, end_row, end_col, action = nil)
    height = end_row - start_row
    width = end_col - start_col
    if action == "loadmore_row"
      width = start_col
      start_col = 1
    end
    if action == "loadmore_col"
      height = start_row
      start_row = 1
    end
    init_two_dimensional_array = Array.new(height) { Array.new(width, false) }
    mines = board.mines.where(x: start_col..end_col, y: start_row..end_row)
    mines_count = mines.count
    mines.each do |mine|
      if action == "loadmore_row"
        init_two_dimensional_array[mine.y - start_row - 1][mine.x - 1] = true
      elsif action == "loadmore_col"
        init_two_dimensional_array[mine.y - 1][mine.x - start_col - 1] = true
      else
        init_two_dimensional_array[mine.y - 1][mine.x - 1] = true
      end
    end
    header_row = action == "loadmore_col" ? (start_col+1..end_col).to_a : [""] + (start_col+1..end_col).to_a
    result = init_two_dimensional_array
    if action != "loadmore_col"
      result = init_two_dimensional_array.map.with_index do |row, index|
        [start_row + index + 1] + row
      end
    end
    result.unshift(header_row) if action == "new" || action == "loadmore_col"
    return mines_count, result
  end
end
