## To run the app:

1. `export STRIPE_API_KEY=xxxxx`
2. `ruby main.rb`

The app will create a `customers.csv` file inside inside of `/tmp` folder. You can edit the filename and path in `main.rb`.

## To run the tests:

1. `rspec`

## Left to do:

- Explore moving `main.rb` logic to a class like `CustomerCsv`.
- Add a test for continuing CSV from last record
- `StripeApi#list_customers` readability can be improved. Ideally, by extracting rate limit handling logic so it can be easily re-used.
- Minor: readability of `Customer.all` could be improved.
- Minor: Fix rubocop warning about using `OpenStruct`.
