require 'pdfbucket/version'

require 'openssl'
require 'digest/sha2'
require 'base64'
require 'uri'

# Main module
module PDFBucket
  DEFAULT_HOST = 'api.pdfbucket.co'
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
    attr_reader :api_key, :api_secret, :api_host

    def initialize(
      api_key: ENV['PDF_BUCKET_API_KEY'],
      api_secret: ENV['PDF_BUCKET_API_SECRET'],
      api_host: ENV['PDF_BUCKET_API_HOST'])

      fail 'bucket api_key is required' if api_key.nil? || api_key.strip.empty?
      fail 'bucket api_secret is required' if api_secret.nil? || api_secret.strip.empty?

      @api_host = api_host || DEFAULT_HOST
      @api_key = api_key
      @api_secret = api_secret
    end

    def generate_url(url, orientation, page_size, margin, zoom)
      signed_uri = encrypt(api_secret, url)

      query = URI.encode_www_form(
        orientation: ORIENTATIONS[orientation],
        page_size: PAGE_SIZES[page_size],
        margin: margin,
        zoom: zoom,
        api_key: api_key,
        signed_uri: signed_uri)

      URI::HTTPS.build(
        host: api_host,
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
