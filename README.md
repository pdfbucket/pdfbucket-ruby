# PDFBucket

This gem allows you to use easily sign URLs to be used with the PDFBucket service.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pdfbucket'
```

And then execute:

```sh
$ bundle
```

## Usage

To sign a URL in your code instantiate a signer object and use its generate_url method.
The new signer will use `PDF_BUCKET_API_KEY`, `PDF_BUCKET_API_SECRET`, `PDF_BUCKET_API_HOST` (default is `pdfbucket.kommit.co`) ENV vars:

```ruby
signer = PDFBucket::Signer.new

# You can also set any the api params, overwriting then ENV vars like this
other_signer = PDFBucket::Signer.new(api_key: '123', api_secret: '321', api_host: 'potion-api-staging.herokuapp.com')

# And you get the signed_url using the sign method
signed_url = signer.generate_url('http://example.com', :landscape, :a4)
```

* Possible values for orientation: :landscape, :portrait
* Possible values for page size: :letter, :a4

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
