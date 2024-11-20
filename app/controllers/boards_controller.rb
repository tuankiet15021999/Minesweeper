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
    data = []
    mines = board.mines.pluck(:x, :y).to_set
    (1..board.width).each do |row|
      row_data = []
      (1..board.height).each do |col|
        row_data<<mines.include?([row, col])
      end
      data<<row_data
    end
    return data
  end
end
