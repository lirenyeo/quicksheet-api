class Api::V1::SpreadsheetsController < ApplicationController
  before_action :api_authentication
  before_action :google_authentication

  def add_expense
    @sheet.add_expense
    render json: {success: "Expense Updated" }, status: :ok
  end

  def add_income
    @sheet.add_income
    render json: {success: "Income Updated" }, status: :ok
  end

  def read
    render @sheet.read_data
  end

  private
  def request_params
    params.permit(:description, :amount, :category, :api_token)
  end

  def api_authentication
    if request_params[:api_token].nil? || ENV['api_token'] != request_params[:api_token]
      render json: { error: "Invalid api token" }, status: :forbidden
    end
  end

  def google_authentication
    @session = SessionService.new.validate
    if @session.blank?
      render json: {error: "Google Auth Error" }, status: :bad_request
    else
      @sheet = SpreadsheetService.new(@session, request_params)
    end
  end
end
