class Api::V1::ExpensesController < ApplicationController

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
    params.permit(:description, :amount, :category)
  end
end
