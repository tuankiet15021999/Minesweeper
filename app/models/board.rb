class Board < ApplicationRecord
  belongs_to :user
  has_many :mines, dependent: :destroy

  validates :name, :width, :height, :num_of_mines, presence: true
  validates :name, uniqueness: true
  validates :width, :height, :num_of_mines, numericality: { greater_than_or_equal_to: 1 }
  validate :check_num_of_mines

  after_create :generate_mines


  def generate_mines
    bombs = self.num_of_mines
  
    bomb_positions = Set.new
    while bomb_positions.size < bombs
      x = rand(1...(self.width+1))
      y = rand(1...(self.height+1))
      bomb_positions << [x, y]
    end
  
    bombs_arr = bomb_positions.map { |x, y| { x: x, y: y } }
    self.mines.insert_all(bombs_arr)
  end
  

  def check_num_of_mines
    max_mines = width.to_i*height.to_i
    errors.add(:num_of_mines, "must be less than equal #{max_mines}") if num_of_mines > max_mines
  end
end
