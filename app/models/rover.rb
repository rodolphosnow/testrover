# Rover commands: L - spin left, R spin right, M - move forward
# Rover can receive commands to move forward or spin through the receive_command method
class Rover
  SPIN_COMMANDS = ['L', 'R'].freeze
  FORWARD_COMMAND = ['M'].freeze
  CARDINAL_POSITIONS = ['W', 'N', 'E', 'S'].freeze
  FORWARD_MOVEMENT_INSTRUCTION = { 
    'N' => 'y += 1',
    'S' => 'y -= 1',
    'W' => 'x -= 1',
    'E' => 'x += 1'
  }.freeze

  def initialize(start_position)
    @position = start_position
  end
  
  def position
    @position
  end

  def receive_command(command)
    case command
    when -> (n) { SPIN_COMMANDS.include?(n) }
      spin(command)
    when -> (n) { FORWARD_COMMAND.include?(n) }
      move_forward
    else
      nil
    end
  end

  def move_forward_preview
    move_command = FORWARD_MOVEMENT_INSTRUCTION[@position[2]]
    x = @position[0]
    y = @position[1]
    eval(move_command)
    pos_array = [ x, y, @position[2] ]
  end

  private

  def change_position(position_array)
    @position = position_array
  end

  def spin(command)
    orientation_index = CARDINAL_POSITIONS.find_index(@position[2])
    case command
    when "L"
      if orientation_index > 0
        new_orientation = CARDINAL_POSITIONS[ orientation_index - 1 ]     
      else
        new_orientation = CARDINAL_POSITIONS[ 3 ]
      end
    when "R"
      if orientation_index < 3
        new_orientation = CARDINAL_POSITIONS[ orientation_index + 1 ]
      else
        new_orientation = CARDINAL_POSITIONS[ 0 ]
      end
    end
    pos_array = [ @position[0],@position[1] ,new_orientation ]
    change_position(pos_array)
  end

  def move_forward
    pos_array = move_forward_preview
    change_position(pos_array)
  end

end