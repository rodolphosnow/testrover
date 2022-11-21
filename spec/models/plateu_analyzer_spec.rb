require "rails_helper"

RSpec.describe PlateuAnalyzer, type: :model do
  describe 'Initializing plateu_analyzer' do 
    context 'With wrong parameters' do
      it 'Should not intialize without a position' do   
        expect { PlateuAnalyzer.new }.to raise_error(ArgumentError)
      end
    end

    context 'With valid parameters' do
      it 'Should receive a position and be initalized' do
        plateu_analyzer = PlateuAnalyzer.new([5, 5])
        expect(plateu_analyzer.max_x).to eq(5)
        expect(plateu_analyzer.max_y).to eq(5)
        expect(plateu_analyzer.rovers).to eq([])
      end
    end
  end

  describe 'Should have a way to include rovers' do
    let(:plateu_analyzer) { PlateuAnalyzer.new([5, 5]) }

    context 'With wrong data' do
      it 'Should not include the rover when the orientation is wrong' do
        plateu_analyzer.include_rover([0,1,"X"])
        expect(plateu_analyzer.rovers).to eq([])
      end

      it 'Should return error if x coordinate data is invalid' do
        plateu_analyzer.include_rover([-1,1,"N"])
        expect(plateu_analyzer.rovers).to eq([])
      end

      it 'Should return error if y coordinate data is invalid' do
        plateu_analyzer.include_rover([0,-1,"N"])
        expect(plateu_analyzer.rovers).to eq([])
      end
    end

    context 'With valid data' do
      it 'Should include a rover' do
        plateu_analyzer.include_rover([3,3,"N"])
        rovers = plateu_analyzer.rovers
        expect(rovers.length).to eq(1)
        expect(rovers[0].class).to eq(Rover)
        expect(rovers[0].position).to eq([3,3,"N"])
      end
    end
  end

  describe 'Should have a way to return all rover`s positions without orientation' do
    let(:plateu_analyzer) { PlateuAnalyzer.new([5, 5]) }

    context 'Without rovers' do
      it 'Should return an empty array' do
        expect(plateu_analyzer.rovers_positions).to eq([])
      end
    end

    context 'With rovers' do
      it 'Should return all rovers positions in an array' do
        plateu_analyzer.include_rover([0,0,"E"])
        plateu_analyzer.include_rover([2,1,"N"])
        positions = plateu_analyzer.rovers_positions
        expect(positions).to eq([[0,0],[2,1]])
      end
    end
  end

  describe 'Should have a way to return all rover`s positions with orientation' do
    let!(:plateu_analyzer) { PlateuAnalyzer.new([5, 5]) }

    context 'Without rovers' do
      it 'Should return an empty array' do
        expect(plateu_analyzer.complete_rovers_positions).to eq([])
      end
    end

    context 'With rovers' do
      it 'Should return all rovers positions in an array' do
        plateu_analyzer.include_rover([0,0,"E"])
        plateu_analyzer.include_rover([2,1,"N"])
        positions = plateu_analyzer.complete_rovers_positions
        expect(positions).to eq([[0,0,"E"],[2,1,"N"]])
      end
    end
  end

  describe 'Should have a way to send command to a rover' do
    let!(:plateu_analyzer) { PlateuAnalyzer.new([5, 5]) }

    context 'With a invalid command' do
      it 'Should not send the command to the rover' do
        plateu_analyzer.include_rover([0,0,"E"])
        rover = plateu_analyzer.rovers[0]
        expect(plateu_analyzer.rovers_positions).to eq([[0,0]])
      end
    end

    context 'With a position already in use' do
      it 'Should not send the command to the rover' do
        plateu_analyzer.include_rover([0,0,"E"])
        plateu_analyzer.include_rover([0,1,"S"])
        rover = plateu_analyzer.rovers[1]
        expect(plateu_analyzer.rovers_positions).to eq([[0,0], [0,1]])
      end
    end

    context 'With valid command' do
      it 'Should move the rover' do
        plateu_analyzer.include_rover([0,0,"E"])
        plateu_analyzer.include_rover([0,1,"N"])
        rover = plateu_analyzer.rovers[1]
        plateu_analyzer.send_rover_command(rover, "M")
        expect(plateu_analyzer.rovers_positions).to eq([[0,0], [0,2]])
      end
    end
  end

end