require "rails_helper"

RSpec.describe "CommunicationController",type: :request do

  describe "POST run_commands" do
    let(:tempfile) { fixture_file_upload('test/files/command.txt') }
    let(:invalid_tempfile) { fixture_file_upload('test/files/invalid_command.txt') }

    it "Assign send the commands to command center" do
      post "/comunication", params: { file: tempfile }
      
      expect(JSON.parse(response.body)).to eq({"data"=>"1 3 N\n5 1 E\n", "status"=>200})
    end

    it "Does not assign send the commands to command center with invalid data" do
      post "/comunication", params: { file: invalid_tempfile }
      
      expect(JSON.parse(response.body)).to eq({"data"=>"error, invalid file", "status"=>422})
    end
  end
end