class SpreadsheetService
  attr_reader :spreadsheet

  def initialize(session, expense)
    @session = session
    @expense = expense
    @current_month = Date::MONTHNAMES[Date.today.in_time_zone.month]
    @current_year = Date.today.in_time_zone.year.to_s
    @spreadsheet_title = "budget-#{@current_month[0..2].downcase}-#{@current_year[2..3]}"
    # @spreadsheet_title = "testing12"
    @template_title = "budget-template"
    @spreadsheet = @session.file_by_title(@spreadsheet_title)
  end

  def add_expense
    create_new_spreadsheet if @spreadsheet.nil?
    save_transaction
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
    previous_balance = previous_spreadsheet.nil? ? "0" : previous_spreadsheet.worksheets[0][9, 9].delete("^0-9-.")

    # Update month, year and balance in the newly created spreadsheet
    worksheet_summary = @spreadsheet.worksheets[0]
    worksheet_summary[2, 2] = Date.today.to_s
    worksheet_summary[2, 12] = previous_balance
    worksheet_summary.save
  end

  def save_transaction
    transaction = @spreadsheet.worksheets[1]

    last_row = transaction.num_rows + 1
    transaction[last_row, 2] = Time.zone.today.to_s
    transaction[last_row, 3] = @expense[:amount]
    transaction[last_row, 4] = @expense[:description]
    transaction[last_row, 5] = @expense[:category]
    transaction.save
  end

  def previous_month_spreadsheet_title(current_month, current_year)
    date = Date.strptime("01 #{current_month} #{current_year}", "%d %B %Y").prev_month
    "budget-#{Date::MONTHNAMES[date.month][0..2].downcase}-#{date.year.to_s[2..3]}"
  end
end
