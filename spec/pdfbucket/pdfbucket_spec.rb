require "spec_helper"

RSpec.describe PDFBucket do
  DEFAULT_HOST  = "api.pdfbucket.io"
  API_KEY       = "22KAQQVVBR8JB731AINT5T1BPV6HCSFG"
  API_SECRET    = "tLW0yQlyRvQ4OEO7azBtE2llYPo/KXh3+W7jjXiAsdk="
  let(:params) do
    {
      uri:          "http://www.google.com",
      orientation:  :landscape,
      page_size:    :a4,
      margin:       "2px",
      zoom:         "0.7",
      expires_in:   10,
      pagination:   true,
      position:     :header,
      alignment:    :center,
      cache:        0
    }
  end

  let(:pdfbucket) { PDFBucket::PDFBucket.new(api_key: API_KEY, api_secret: API_SECRET, api_host: DEFAULT_HOST) }

  describe "Initial object" do
    it "instantiate a PDFBucket::PDFBucket with and api_host, api_key and api_secret" do
      expect(pdfbucket.api_host).to eq(DEFAULT_HOST)
      expect(pdfbucket.api_key).to eq(API_KEY)
      expect(pdfbucket.api_secret).to eq(API_SECRET)
    end
  end

  describe "PDFBucket::PDFBucket valid methods" do
    it "#generate_url without optional params" do
      optional_params_uri = pdfbucket.generate_url(params[:uri], params[:orientation], params[:page_size], params[:margin], params[:zoom])
      encrypted_uri = optional_params_uri.split("encrypted_uri=").last
      expect(optional_params_uri).to eq("https://#{DEFAULT_HOST}/api/convert?orientation=landscape&page_size=A4&margin=2px&zoom=0.7&expires_in=0&api_key=#{API_KEY}&encrypted_uri=#{encrypted_uri}")
    end

    let(:generate_url) { pdfbucket.generate_url(params[:uri], params[:orientation], params[:page_size], params[:margin], params[:zoom], params[:expires_in], params[:pagination], params[:position], params[:alignment]) }

    it "#generate_url" do
      encrypted_uri = generate_url.split("encrypted_uri=").last.split("&pagination").first
      expect(generate_url).to eq("https://#{DEFAULT_HOST}/api/convert?orientation=landscape&page_size=A4&margin=2px&zoom=0.7&expires_in=10&api_key=#{API_KEY}&encrypted_uri=#{encrypted_uri}&pagination=true&position=header&alignment=center")
    end

    let(:generate_plain_url) { pdfbucket.generate_plain_url(params[:uri], params[:orientation], params[:page_size], params[:margin], params[:zoom], params[:expires_in], params[:pagination], params[:position], params[:alignment]) }

    it "#generate_plain_url" do
      expect(generate_plain_url).to eq("https://#{DEFAULT_HOST}/api/convert?orientation=landscape&page_size=A4&margin=2px&zoom=0.7&expires_in=10&api_key=#{API_KEY}&uri=http%3A%2F%2Fwww.google.com&signature=8cf3be71d48bd12ba3103ccc69b77424ec8adaf8&pagination=true&position=header&alignment=center")
    end
  end

  describe "PDFBucket::PDFBucket invalid object" do
    it "has invalid alignment" do
      generate_url = pdfbucket.generate_url(params[:uri], params[:orientation], params[:page_size], params[:margin], params[:zoom], params[:expires_in], params[:pagination], params[:position], "")
      body = http_body(generate_url)
      expect(body).to include("Invalid alignment, posible values are: left, center or right")
   end

    it "has invalid position" do
      generate_url = pdfbucket.generate_url(params[:uri], params[:orientation], params[:page_size], params[:margin], params[:zoom], params[:expires_in], params[:pagination], "", params[:alignment])
      body = http_body(generate_url)
      expect(body).to include("Invalid position, posible values are: header or footer")
    end

    it "has invalid orientation" do
      generate_url = pdfbucket.generate_url(params[:uri], "", params[:page_size], params[:margin], params[:zoom], params[:expires_in], params[:pagination], params[:position], params[:alignment])
      body = http_body(generate_url)
      expect(body).to include("Invalid orientation, posible values are: landscape or portrait")
    end
  end

  def http_body(url)
    uri = URI(url)
    Net::HTTP.get_response(uri).body
  end
end
