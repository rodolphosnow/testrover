class ComunicationController < ApplicationController
  def run_commands
    data_obj = DataValidation.read_file(params[:file])
    if data_obj.present?
      positions = CommandCenter.new.run_commands(data_obj[:top_right_position], data_obj[:rovers_array])
      result = DataValidation.positions_string(positions)
      render json: {data: result, status: 200}
    else
      render json: {data: "error, invalid file", status: 422}
    end
  end
end