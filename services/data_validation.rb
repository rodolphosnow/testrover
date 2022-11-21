#This class will validate input data and do some conversions so the system dont need to worry about conversions
class DataValidation
  VALID_MOVEMENT_INPUTS = ['L', 'R', 'M'].freeze.freeze

  def self.read_file(file)
    text = file.read
    text_array = text.split("\n")
    return false unless validate_top_right_coordinate(text_array[0])

    top_right_position = plateu_top_right_array(text_array[0])

    rovers_array = []
    text_array[1..-1].each_slice(2) do |start_position, commands|
      if validate_start_position(start_position) && validate_commands(commands)
        rovers_array << {
          start_position: rover_start_position_array(start_position),
          commands: commands_array(commands),
        }
      end
    end
    response = {
      top_right_position: top_right_position,
      rovers_array: rovers_array,
    }
    return response
  rescue => ex
    return 'invalid file data, please review the file and try again'
  end

  def self.validate_top_right_coordinate(coordinate)
    return false unless coordinate.class == String

    return false unless coordinate[/\d\s\d/].present?

    number_array = coordinate.split(" ")
    return validate_positive_numbers(number_array)
  end

  #regex to validate the starting position pattern
  def self.validate_start_position(position)
    return false unless position.class == String

    return false unless position[/\d\s\d\s[WNES]/].present?

    number_array = position.split(" ")
    return validate_positive_numbers(number_array[0..1])
  end

  def self.validate_positive_numbers(array)
    array.each do |number_string|
      return false unless number_string.to_i >= 0
    end
    return true
  end

  def self.validate_commands(commands)
    return false unless commands.class == String
    
    command_array = commands.split("")
    command_array.each do |command| 
      return false if !VALID_MOVEMENT_INPUTS.include?(command)
    end
    return true
  end

  def self.rover_start_position_array(position)
    return false unless validate_start_position(position)
    
    arr = position.split(" ")
    return [arr[0].to_i, arr[1].to_i, arr[2]]
  end

  def self.plateu_top_right_array(position)
    return false unless validate_top_right_coordinate(position)
    
    arr = position.split(" ")
    return [arr[0].to_i, arr[1].to_i]
  end

  def self.commands_array(commands)
    return false unless validate_commands(commands)

    arr = commands.split("")
  end

  def self.positions_string(positions)
    string = ""
    positions.each do |position|
      string << "#{position[0]} #{position[1]} #{position[2]}\n"
    end
    string
  end

  

end