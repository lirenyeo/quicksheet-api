# QuickSheet API

API endpoint to insert values into google budgeting spreadsheets. Takes 3 params: amount, description and category.

## How It Works

* Determine today's month, go to the spreadsheet of the month and insert amount, description and category of your expense.
* If spreadsheet does not exist, create a new one based on current month, and update the starting balance based on previous-month-spreadsheet.

