# QuickSheets API

Frequent data input to google spreadsheets with native mobile app is troublesome. This API is meant for quick data input to personal google spreadsheets such as budgeting/finance spreadsheets, it also allows data reading from sheets.

This API has 3 endpoints: `expense`, `income` and `data`.

`expense` and `income` take 3 params: `amount`, `description` and `category`, and insert these values into your budgeting spreadsheets.

GET `data` retrieves the following values: `actual_income`, `actual_expense`, `monthly_balance` and `total_balance`.

## How It Works

* Determine today's month, go to the spreadsheet of the month and insert amount, description and category of your expense.
 * *The spreadsheet naming follows the format of `budget-<first-3-letter-of-month>-<YY>`*

* If spreadsheet does not exist, create a new one based on current month, and update the starting balance based on previous-month-spreadsheet.
 * *So calling this API in January 2017 will create a spreadsheet named `budget-jan-17` where the starting balance is retrieved from `budget-dec-16`. Starting balance will be defaulted to 0 if previous-month spreadsheet does not exist.*

* The newly-created spreadsheet is cloned from a template spreadsheet named 'budget-template'
 * *Spreadsheets will be created inside the same google-drive folder as `budget-template`.*
 
## Disclaimer

* Currently all rows/columns numbers and spreadsheets names are hardcoded to accustom the googlesheets budgeting template as shown below.

* I intend to release V2 with database which allows these settings to be modified and stored.

## Resources

* This API is designed based on the usage of the following template:
[Googlesheets Template](https://drive.google.com/open?id=1tU1mPUYVNNa1wj4Yl3w9tjxNrhsjmNNMUxStLbDxbpk)

* I have also created a hybrid mobile app (Ionic) that implements this API endpoint:
[Quicksheets Mobile App](https://github.com/lirenyeo/quicksheets-mobile)
