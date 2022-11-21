#Class to Analyze Plateou valid positions, such as
# positions that are out of the plateu reach,
# positions that already have rovers
# The PlateuAnalyzer assumes that if a position is invalid the rover will stop completely,
# not running any other command in its chain command

class PlateuAnalyzer
  attr_accessor :rovers
  attr_accessor :max_x
  attr_accessor :max_y

  def initialize(top_right_coordinate)
    @max_x = top_right_coordinate[0]
    @max_y = top_right_coordinate[1]
    @rovers = []
  end

  def include_rover(rover_coordinates)
    valid, message = validate_poisiton(rover_coordinates)
    if valid
      rover = Rover.new(rover_coordinates)
      @rovers << rover
    end
  end

  def send_rover_command(rover, command)
    valid_command = false
    case command
    when -> (n) { Rover::SPIN_COMMANDS.include?(n) }
      valid_command = true
    when -> (n) { Rover::FORWARD_COMMAND.include?(n) }
      future_position = rover.move_forward_preview
      valid_command, message = validate_poisiton(future_position)
    else
      raise StandardError.new('Invalid command')
    end
    rover.receive_command(command) if valid_command
  end

  def rovers_positions
    positions_array = []
    rovers.each do |rover|
      positions_array << [ rover.position[0], rover.position[1] ] 
    end
    positions_array
  end

  def complete_rovers_positions
    positions_array = []
    rovers.each do |rover|
      positions_array << rover.position
    end
    positions_array
  end

  def validate_poisiton(position)
    if position[0] > @max_x  || position[0] < 0
      return false, 'Invalid position X'
    elsif position[1] > @max_y  || position[1] < 0
      return false, 'Invalid position Y'
    elsif !Rover::CARDINAL_POSITIONS.include?(position[2])
      return false, 'Invalid rover orientation'
    elsif rovers_positions.include?(position[0..1])
      return false, 'Position has another rover'
    else
      return true, 'Valid command'
    end
  end

end