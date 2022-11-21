require "rails_helper"

RSpec.describe CommandCenter, type: :model do
  context 'Should be able to start a plateu mapping' do
    it 'start the plateu mapping and return the plateu obj' do
      plateu_analyzer = CommandCenter.new.send(:start_plateu, [4,5])
      expect(plateu_analyzer.class).to eq(PlateuAnalyzer)
      expect(plateu_analyzer.max_x).to eq(4)
      expect(plateu_analyzer.max_y).to eq(5)
    end
  end

  context 'Should run commands and provide their execution' do
    it do
      rovers_array = [
        {
          start_position: [1, 2, "N"],
          commands: ["L", "M", "L", "M", "L", "M", "L", "M", "M"],
        },
        {
          start_position: [3, 3, "E"],
          commands: ["M", "M", "R", "M", "M", "R", "M", "R", "R", "M"],
        }
      ]
      data_obj = {
        top_right_position: [5, 5],
        rovers_array: rovers_array,
      }
      response = CommandCenter.new.run_commands(data_obj[:top_right_position], data_obj[:rovers_array])
      expect(response).to eq([[1, 3, "N"],[5, 1, "E"]])
    end
  end
end