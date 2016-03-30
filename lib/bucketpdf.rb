require 'bucketpdf/version'

module Bucketpdf
  # Main class
  class Signer
    attr_reader :api_key, :api_secret

    def initialize(
      api_key: ENV['BUCKET_PDF_API_KEY'],
      api_secret: ENV['BUCKET_PDF_API_SECRET'])

      fail 'bucket api_key is required' if api_key.nil? || api_key.strip.empty?
      fail 'bucket api_secret is required' if api_secret.nil? || api_secret.strip.empty?

      @api_key = api_key
      @api_secret = api_secret
    end

    def sign(url, orientation, page_size)
      # TODO
    end
  end
end
