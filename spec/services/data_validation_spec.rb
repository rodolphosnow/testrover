require "rails_helper"

RSpec.describe 'DataValidation' do
  let(:data_validation) { DataValidation }
  describe 'Should validate file content' do
    context 'With invalid data' do
      it 'Should return false' do
        data = "-5 5\n1 2 N\nLML\n3 3 E\nMR"
        tempfile = Tempfile.create { |f| f << data }
        response = DataValidation.read_file(tempfile)
        expect(response).to eq('invalid file data, please review the file and try again')
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