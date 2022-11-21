require "rails_helper"

RSpec.describe "CommunicationController",type: :request do

  describe "POST run_commands" do
    let(:tempfile) { fixture_file_upload('test/files/command.txt') }

    it "assigns send the commands to command center" do
      post "/comunication", params: { file: tempfile }
      
      expect(JSON.parse(response.body)).to eq({"data"=>"1 3 N\n5 1 E\n", "status"=>200})
      expect(assigns(:teams)).to eq([team])
    end
  end
end