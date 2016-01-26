def move(snake, direction)
  (moved_snake = grow(snake, direction)).shift
  moved_snake
end

def grow(snake, direction)
  moved_snake = snake.dup
  moved_snake << [snake.last[0] + direction[0], snake.last[1] + direction[1]]
end

def new_food(food, snake, dimensions)
  x_array = 0.upto(dimensions[:width] - 1).to_a
  y_array = 0.upto(dimensions[:height] - 1).to_a
  (x_array.product(y_array) - food - snake).sample
end

def obstacle_ahead?(snake, direction, dimensions)
  moved_snake = move(snake, direction)
  return true if out_of_bounds?(moved_snake, dimensions)
  return true if snake.include?(moved_snake.last)
  false
end

def danger?(snake, direction, dimensions)
  moved_snake = move(snake, direction)
  return true if (obstacle_ahead?(snake, direction, dimensions))
  return true if (obstacle_ahead?(moved_snake, direction, dimensions))
  false
end

def out_of_bounds?(snake, dimensions)
  return true if (snake.last.first < 0) or (snake.last.last < 0 )
  return true if (dimensions[:width] <= snake.last.first)
  return true if (dimensions[:height] <= snake.last.last)
  false
end