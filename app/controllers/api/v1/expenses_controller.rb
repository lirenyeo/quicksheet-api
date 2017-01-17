class Api::V1::ExpensesController < ApplicationController
  before_action :authentication
  
  def create
    auth = SessionService.new
    session = auth.validate

    if session.blank?
      render json: {error: "Google Auth Error" }, status: :bad_request
    else
      sheet = SpreadsheetService.new(session, request_params)
      sheet.add_expense
      render json: {success: "Spreadsheet updated" }, status: :ok
    end

  end

  private
  def request_params
    params.permit(:description, :amount, :category, :api_token)
  end

  def authentication
    if request_params[:api_token].nil? || ENV['api_token'] != request_params[:api_token]
      render json: { error: "Invalid api token" }, status: :forbidden
    end
  end
end
