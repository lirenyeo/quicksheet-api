class SpreadsheetService
  attr_reader :spreadsheet

  def initialize(session, params)
    @session = session
    @params = params
    @current_month = Date::MONTHNAMES[Date.today.in_time_zone.month]
    @current_year = Date.today.in_time_zone.year.to_s
    @spreadsheet_title = "budget-#{@current_month[0..2].downcase}-#{@current_year[2..3]}"
    # @spreadsheet_title = "testing12"
    @template_title = "budget-template"
    @spreadsheet = @session.file_by_title(@spreadsheet_title)
  end

  def add_expense
    create_new_spreadsheet if @spreadsheet.nil?
    save_transaction("expense")
  end

  def add_income
    create_new_spreadsheet if @spreadsheet.nil?
    save_transaction("income")
  end

  def read_data
    summary_sheet = @spreadsheet.worksheets[0]

    return {
      json: {
        actual_income: summary_sheet[16, 9],
        actual_expense: summary_sheet[16, 3],
        monthly_balance: summary_sheet[9, 9],
        final_balance: summary_sheet[11, 5]
        }, status: :ok
    }
  end
  
  private

  def create_new_spreadsheet
    # Make a clone from template file
    @session.file_by_title(@template_title).copy(@spreadsheet_title)
    # Spreadsheet for current month
    @spreadsheet = @session.spreadsheet_by_title(@spreadsheet_title)
    # Spreadsheet for previous month
    previous_spreadsheet = @session.spreadsheet_by_title(previous_month_spreadsheet_title(@current_month, @current_year))

    # Get previous balance from previous month spreadsheet
    previous_balance = previous_spreadsheet.nil? ? "0" : previous_spreadsheet.worksheets[0][11, 5].delete("^0-9-.")

    # Update month, year and balance in the newly created spreadsheet
    worksheet_summary = @spreadsheet.worksheets[0]
    worksheet_summary[2, 2] = Date.today.to_s
    worksheet_summary[2, 12] = previous_balance
    worksheet_summary.save
  end

  def save_transaction(type)
    start_col = 
      if type == "expense"
        2
      elsif type == "income"
        7
      end

    transaction = @spreadsheet.worksheets[1]

    last_row = transaction.num_rows_at(start_col) + 1
    transaction[last_row, start_col] = Time.zone.today.to_s
    transaction[last_row, start_col + 1] = @params[:amount]
    transaction[last_row, start_col + 2] = @params[:description]
    transaction[last_row, start_col + 3] = @params[:category]
    transaction.save
  end

  def previous_month_spreadsheet_title(current_month, current_year)
    date = Date.strptime("01 #{current_month} #{current_year}", "%d %B %Y").prev_month
    "budget-#{Date::MONTHNAMES[date.month][0..2].downcase}-#{date.year.to_s[2..3]}"
  end
end
