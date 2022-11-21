require "rails_helper"

RSpec.describe 'DataValidation' do
  let(:data_validation) { DataValidation }
  describe 'Should validate file content' do
    context 'With invalid data' do
      it 'Should return false' do
        data = "-5 5\n1 2 N\nLML\n3 3 E\nMR\n"
        tempfile = Tempfile.new
        tempfile.write(data)
        tempfile.rewind
        response = DataValidation.read_file(tempfile)
        expect(response).to eq(false)
      end
    end

    context 'With valid data' do
      it 'Should return data object' do
        rovers_array = [
          {
            start_position: [1, 2, "N"],
            commands: ["L", "M", "L"],
          },
          {
            start_position: [3, 3, "E"],
            commands: ["M", "R"],
          }
        ]
        expected_response = {
          top_right_position: [5, 5],
          rovers_array: rovers_array,
        }
        data = "5 5\n1 2 N\nLML\n3 3 E\nMR\n"
        tempfile = Tempfile.new
        tempfile.write(data)
        tempfile.rewind

        response = DataValidation.read_file(tempfile)
        expect(response).to eq(expected_response)
      end
    end
  end

  describe 'Should have a way to validate rover start position input' do
    context 'With invalid data' do
      it 'Should return false' do
        response = DataValidation.validate_start_position("0 0 T")
        expect(response).to eq(false)
      end
    end

    context 'With valid data' do
      it 'Should return true' do
        response = DataValidation.validate_start_position("0 0 N")
        expect(response).to eq(true)
      end
    end
  end

  describe 'Should have a way to validate commmands inputs' do
    context 'With invalid inputs' do
      it 'Should return false' do
        response = DataValidation.validate_commands("LLLMMMMMA")
        expect(response).to eq(false)
      end
    end

    context 'With valid inputs' do
      it 'Should return true' do
        response = DataValidation.validate_commands("LLLMMMMM")
        expect(response).to eq(true)
      end
    end
  end#This class will validate input data and do some conversions so the system dont need to worry about conversions
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

  describe 'Should have a way to validate if coordinate numbers are positive' do
    context 'With negative numbers input' do
      it 'Should return false' do
        response = DataValidation.validate_positive_numbers([-1, 1])
        expect(response).to eq(false)
      end
    end

    context 'With positive numbers input' do
      it 'Should return false' do
        response = DataValidation.validate_positive_numbers([0, 0])
        expect(response).to eq(true)
      end
    end
  end

  describe 'Should have a way to top righ coordinates' do
    context 'With invalid top right coordinates' do
      it 'Should return true' do
        response = DataValidation.validate_top_right_coordinate("-1 5")
        expect(response).to eq(false)
      end
    end

    context 'With valid top right coordinates' do
      it 'Should return true' do
        response = DataValidation.validate_top_right_coordinate("5 5")
        expect(response).to eq(true)
      end
    end
  end

  describe 'Convert inputs to array' do
    context 'Convert start_position to array' do
      it 'With valid position should return an array' do
        response = DataValidation.rover_start_position_array("1 1 N")
        expect(response).to eq([1, 1, "N"])
      end

      it 'With invalid position should return false' do
        response = DataValidation.validate_top_right_coordinate("-1 5 N")
        expect(response).to eq(false)
      end
    end

    context 'Convert plateu_top_right_array to array' do
      it 'With valid position should return an array' do
        response = DataValidation.plateu_top_right_array("5 5")
        expect(response).to eq([5, 5])
      end

      it 'With invalid position should return false' do
        response = DataValidation.validate_top_right_coordinate("-1 5")
        expect(response).to eq(false)
      end
    end

    context 'Convert commands_array to array' do
      it 'With valid command should return an array' do
        response = DataValidation.commands_array("ML")
        expect(response).to eq(["M","L"])
      end

      it 'With invalid command should return false' do
        response = DataValidation.commands_array("MTMLMLR")
        expect(response).to eq(false)
      end
    end
  end

end