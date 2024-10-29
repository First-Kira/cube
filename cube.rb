# 3D Cube rotation in Ruby without external libraries (Command-line ASCII art)

# Define cube vertices in 3D space
vertices = [
  [-1, -1, -1], [1, -1, -1], [1, 1, -1], [-1, 1, -1],
  [-1, -1,  1], [1, -1,  1], [1, 1,  1], [-1, 1,  1]
]

# Define edges connecting vertices
edges = [
  [0, 1], [1, 2], [2, 3], [3, 0],
  [4, 5], [5, 6], [6, 7], [7, 4],
  [0, 4], [1, 5], [2, 6], [3, 7]
]

angle_x = 0
angle_y = 0

# Rotation matrices for 3D transformations
def rotate_x(point, angle)
  x, y, z = point
  [
    x,
    y * Math.cos(angle) - z * Math.sin(angle),
    y * Math.sin(angle) + z * Math.cos(angle)
  ]
end

def rotate_y(point, angle)
  x, y, z = point
  [
    x * Math.cos(angle) + z * Math.sin(angle),
    y,
    -x * Math.sin(angle) + z * Math.cos(angle)
  ]
end

# ASCII rendering of the cube in terminal
loop do
  system("clear") || system("cls") # Clear screen for each frame

  # Rotate and project points to 2D
  projected_points = vertices.map do |v|
    rotated_x = rotate_x(v, angle_x)
    rotated_y = rotate_y(rotated_x, angle_y)
    scale = 10 / (2 - rotated_y[2]) # Basic perspective scaling
    [(rotated_y[0] * scale).to_i + 20, (rotated_y[1] * scale).to_i + 10]
  end

  # Initialize 2D grid for display
  display = Array.new(20) { Array.new(40, " ") }

  # Draw cube edges on the grid
  edges.each do |(i, j)|
    x1, y1 = projected_points[i]
    x2, y2 = projected_points[j]

    # Draw lines by marking points between the vertices
    dx = x2 - x1
    dy = y2 - y1
    steps = [dx.abs, dy.abs].max
    (0..steps).each do |step|
      x = x1 + dx * step / steps
      y = y1 + dy * step / steps
      display[y][x] = "*" if y.between?(0, 19) && x.between?(0, 39)
    end
  end

  # Print display grid
  display.each { |row| puts row.join }

  # Update rotation angles
  angle_x += 0.05
  angle_y += 0.03

  sleep(0.1) # Frame delay for visible animation
end

