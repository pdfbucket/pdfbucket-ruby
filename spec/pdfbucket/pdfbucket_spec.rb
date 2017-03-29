require "spec_helper"

RSpec.describe PDFBucket do
  API_KEY     = "PIQ7T3GOM7D36R0O67Q97UM3F0I6CPB5"
  API_SECRET  = "HieMN8dvi5zfSbKvqxKccxDo3LozqOIrY59U/jrZY54="
  let(:params) do
    {
      uri:          "http://www.google.com",
      orientation:  :landscape,
      page_size:    :a4,
      margin:       "2px",
      zoom:         "0.7",
      pagination:   "true",
      position:     :header,
      alignment:    :center,
      expires_in:   10,
      cache:        0
    }
  end

  let(:pdfbucket) { PDFBucket::PDFBucket.new(api_key: API_KEY, api_secret: API_SECRET) }

  describe "Initial object" do
    it "instantiate a PDFBucket::PDFBucket with and api_host, api_key and api_secret" do
      expect(pdfbucket.api_host).to eq("api.pdfbucket.io")
      expect(pdfbucket.api_key).to eq(API_KEY)
      expect(pdfbucket.api_secret).to eq(API_SECRET)
    end
  end

  describe "PDFBucket::PDFBucket valid methods" do
    let(:generate_url) { pdfbucket.generate_url(params[:uri], params[:orientation], params[:page_size], params[:margin],
                         params[:zoom], params[:pagination], params[:position], params[:alignment], params[:expires_in]) }

    it "#generate_url" do
      encrypted_uri = generate_url.split("encrypted_uri").last
      expect(generate_url).to eq("https://api.pdfbucket.io/api/convert?orientation=landscape&page_size=A4&margin=2px&zoom=0.7&pagination=true&position=header&alignment=center&expires_in=10&api_key=PIQ7T3GOM7D36R0O67Q97UM3F0I6CPB5&encrypted_uri#{encrypted_uri}")
    end

    let(:generate_plain_url) { pdfbucket.generate_plain_url(params[:uri], params[:orientation], params[:page_size], params[:margin],
                              params[:zoom], params[:pagination], params[:position], params[:alignment], params[:expires_in]) }

    it "#generate_plain_url" do
      expect(generate_plain_url).to eq("https://api.pdfbucket.io/api/convert?orientation=landscape&page_size=A4&margin=2px&zoom=0.7&pagination=true&position=header&alignment=center&expires_in=10&api_key=PIQ7T3GOM7D36R0O67Q97UM3F0I6CPB5&uri=http%3A%2F%2Fwww.google.com&signature=9fa0abf62662ed62f7b383d7aad5bc6c892c0455")
    end
  end

  describe "PDFBucket::PDFBucket invalid object" do
    it "has invalid alignment" do
      generate_url = pdfbucket.generate_url(params[:uri], params[:orientation], params[:page_size], params[:margin], params[:zoom], params[:pagination], params[:position], "", params[:expires_in])
      body = http_body(generate_url)
      expect(body).to include("Invalid alignment, posible values are: left, center or right")
   end

    it "has invalid position" do
      generate_url = pdfbucket.generate_url(params[:uri], params[:orientation], params[:page_size], params[:margin], params[:zoom], params[:pagination], "", params[:alignment], params[:expires_in])
      body = http_body(generate_url)
      expect(body).to include("Invalid position, posible values are: header or footer")
    end

    it "has invalid pagination" do
      generate_url = pdfbucket.generate_url(params[:uri], params[:orientation], params[:page_size], params[:margin], params[:zoom], "", params[:position], params[:alignment], params[:expires_in])
      body = http_body(generate_url)
      expect(body).to include("Invalid pagination, posible values are: true or false")
    end

    it "has invalid orientation" do
      generate_url = pdfbucket.generate_url(params[:uri], "", params[:page_size], params[:margin], params[:zoom], params[:pagination], params[:position], params[:alignment], params[:expires_in])
      body = http_body(generate_url)
      expect(body).to include("Invalid orientation, posible values are: landscape or portrait")
    end
  end

  def http_body(url)
    uri = URI(url)
    Net::HTTP.get_response(uri).body
  end
end
