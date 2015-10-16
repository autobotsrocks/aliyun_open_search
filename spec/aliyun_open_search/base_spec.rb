require "spec_helper"

describe AliyunOpenSearch::Base do
  context "AliyunOpenSearch::Base.signature" do
    it "signatures params" do
      signature = AliyunOpenSearch::Base.signature(a: 1)
      expect(signature).to eq "yHE9b738jZdhYmbDTFsgUncQ4go="
    end
  end

  context "AliyunOpenSearch::Base.new.signature_nonce" do
    it "generates a string which is 17 random numbers" do
      expect(AliyunOpenSearch::Base.send(:signature_nonce).size).to eq 17
    end
  end

  context "AliyunOpenSearch::Base.new.uri(params)" do
    it "splices together all params" do
      params = { "Timestamp" => Time.parse("2015-01-10").utc.iso8601 }
      url = "#{ENV["OPEN_SEARCH_HOST"]}?Timestamp=2015-01-09T16%3A00%3A00Z"

      expect(
        AliyunOpenSearch::Base.new.uri(ENV["OPEN_SEARCH_HOST"], params)
      ).to eq URI(url)
    end
  end
end
