require "rails_helper"

RSpec.describe Rover, type: :model do
  describe 'Initializing Rover' do
    context 'Initializing with wrong parameters' do 
      it 'Should not intialize without a position' do   
        expect { Rover.new }.to raise_error(ArgumentError)
      end
    end

    context 'Initializing with valid parameters' do
      it 'Should receive a position and be initalized' do
        rover = Rover.new([0, 0, "N"])
        expect(rover.position).to eq([0, 0, "N"])
      end
    end
  end

  describe 'Validation rover methods' do
    let(:rover) { Rover.new([0, 0, "N"]) }

    it 'Should have a way to change position' do
      rover.send(:change_position, [1, 1, "E"])
      expect(rover.position).to eq([1, 1, "E"])
    end

    it 'Should have a way to turn left or right' do
      rover.send(:spin, "R")
      expect(rover.position).to eq([0, 0, "E"])
      rover.send(:spin, "L")
      expect(rover.position).to eq([0, 0, "N"])
    end

    it 'Should have a way to move forward' do
      rover.send(:move_forward)
      expect(rover.position).to eq([0, 1, "N"])
    end

    it 'Should have a way to receive a command' do
      expect(rover.respond_to?(:receive_command)).to be_truthy
      rover.receive_command("M")
      expect(rover.position).to eq([0, 1, "N"])
      rover.receive_command("L")
      expect(rover.position).to eq([0, 1, "W"])
      rover.receive_command("R")
      expect(rover.position).to eq([0, 1, "N"])
    end
  end
end