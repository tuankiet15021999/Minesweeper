class Board < ApplicationRecord
  belongs_to :user
  has_many :mines, dependent: :destroy

  validates :name, :width, :height, :num_of_mines, presence: true
  validates :name, uniqueness: true
  validates :width, :height, :num_of_mines, numericality: { greater_than_or_equal_to: 1 }
  validate :check_num_of_mines

  after_create :generate_mines


  def generate_mines
    col_num = self.width
    row_num = self.height
    bombs = self.num_of_mines
    bombs_arr = []
    bomb_hash = {}
    while bombs_arr.size <= bombs
      bomb_position = {x: 1+rand(col_num), y: 1+rand(row_num)}
      next if bomb_hash[[bomb_position[:x], bomb_position[:y]]]
      bomb_hash[[bomb_position[:x], bomb_position[:y]]] = true
      bombs_arr << bomb_position
    end
    
    self.mines.insert_all(bombs_arr)
  end

  def check_num_of_mines
    max_mines = width.to_i*height.to_i
    errors.add(:num_of_mines, "must be less than equal #{max_mines}") if num_of_mines > max_mines
  end
end
