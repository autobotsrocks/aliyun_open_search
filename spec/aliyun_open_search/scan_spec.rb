require "spec_helper"

RSpec.describe AliyunOpenSearch::Scan do
  let(:app_name) { ENV.fetch("APP_NAME") }
  context "AliyunOpenSearch::Scan.new" do
    before do
      @scan_service = AliyunOpenSearch::Scan.new(app_name)
    end

    it "sends first request to get request_id" do
      expect(@scan_service.scroll_id.length).to be > 0
    end

    it "returns result" do
      @scan_service.execute
      result = JSON.parse(@scan_service.result)["result"]

      expect(@scan_service.scroll_id.length).to be > 0
      expect(result["items"].size).to be > 0
    end

    it "supports chain to get next results" do
      @scan_service.execute.execute.execute

      expect(@scan_service.scroll_id.length).to be > 0
    end
  end
end
