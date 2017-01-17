# QuickSheet API

API endpoint to insert values into google budgeting spreadsheets. Takes 3 params: amount, description and category.

## How It Works

* Determine today's month, go to the spreadsheet of the month and insert amount, description and category of your expense.

* If spreadsheet does not exist, create a new one based on current month, and update the starting balance based on previous-month-spreadsheet.

* The newly-created spreadsheet is cloned from a template spreadsheet named 'budget-template'

## Resources

* This API is designed based on the usage of the following template:
[Googlesheets Template](https://drive.google.com/open?id=1tU1mPUYVNNa1wj4Yl3w9tjxNrhsjmNNMUxStLbDxbpk)

* I have also created a hybrid mobile app (Ionic) that implements this API endpoint:
[Ionic Budget App](https://github.com/lirenyeo/ionic-budget-app)

