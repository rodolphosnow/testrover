# CommandCenter is the class that act as a way to start a plateu mapping and let 
# insert commands to deploy and command rovers through the PlateuAnalyzer
# if a invalid movement command is given, the rover will stop the chain of command
# if a invalid start position is given, it won't deploy the rover

class CommandCenter
  attr_accessor :plateu_analyzer

  def run_commands(top_right_coord, rovers_array)
    start_plateu(top_right_coord)
    rovers_array.each do |rover_data|
      deploy_rover(rover_data[:start_position])
      rover = plateu_analyzer.rovers.last  
      send_commands(rover, rover_data[:commands])
    end
    return plateu_analyzer.complete_rovers_positions
  end

  def rover_positions
    plateu_analyzer.complete_rovers_positions
  end

  private

  def start_plateu(top_right_coordinate)
    @plateu_analyzer = PlateuAnalyzer.new(top_right_coordinate)
  end

  def deploy_rover(position)
    plateu_analyzer.include_rover(position)
  end

  def send_commands(rover, commands)
    commands.each do |command|
      plateu_analyzer.send_rover_command(rover, command)
    end
  end

end