require 'bucketpdf/version'

require 'openssl'
require 'digest/sha2'
require 'base64'
require 'uri'

# Main module
module Bucketpdf
  HOST_BUCKET_PDF = 'potion-api-staging.herokuapp.com'
  ORIENTATIONS = {
    portrait: 'portrait',
    landscape: 'landscape'
  }
  PAGE_SIZES = {
    a4: 'A4',
    letter: 'Letter'
  }

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
      signed_uri = encrypt(api_secret, url)

      query = URI.encode_www_form(
        orientation: ORIENTATIONS[orientation],
        page_size: PAGE_SIZES[page_size],
        api_key: api_key,
        signed_uri: signed_uri)

      URI::HTTPS.build(
        host: HOST_BUCKET_PDF,
        path: '/api/convert',
        query: query).to_s
    end

    private

    def encrypt(key, content)
      binary_key = Base64.decode64(key)
      alg = 'AES-256-CTR'
      iv = OpenSSL::Cipher::Cipher.new(alg).random_iv
      aes_ctr = OpenSSL::Cipher::Cipher.new(alg)
      aes_ctr.encrypt
      aes_ctr.key = binary_key
      aes_ctr.iv = iv

      cipher = aes_ctr.update(content)
      cipher << aes_ctr.final

      Base64.strict_encode64(iv + cipher)
    end
  end
end
