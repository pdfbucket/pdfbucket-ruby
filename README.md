# PDFBucket

This gem allows you to integrate easily with the PDFBucket service.

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

To encrypt a URL in your code instantiate a PDFBucket object and use its generate_url method.
The new pdf_bucket will use `PDF_BUCKET_API_KEY`, `PDF_BUCKET_API_SECRET`, `PDF_BUCKET_API_HOST` (default is `api.pdfbucket.io`) ENV vars:

```ruby
pdf_bucket = PDFBucket::PDFBucket.new

# You can also set any the api params, overwriting then ENV vars like this
other_pdf_bucket = PDFBucket::PDFBucket.new(api_key: '123', api_secret: '321', api_host: 'api.example.com')

# And you get the encrypted_url using the generate_url method
encrypted_url = pdf_bucket.generate_url('http://example.com', :landscape, :a4, '2px', '0.7')
```

* Possible values for orientation: :landscape, :portrait
* Possible values for page size: :letter, :a4
* Possible values for margin: https://developer.mozilla.org/en-US/docs/Web/CSS/margin#Formal_syntax
* Possible values for zoom: https://developer.mozilla.org/en-US/docs/Web/CSS/@viewport/zoom#Formal_syntax


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
