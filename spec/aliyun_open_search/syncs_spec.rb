require "spec_helper"

RSpec.describe AliyunOpenSearch::Syncs do
  let(:params) do
    {
      action: :push,
      table_name: :cars,
      items: [
        {
          "cmd" => "update",
          "timestamp" => 1_420_070_400_010,
          "fields" => {
            "id" => "121139313135",
            "styl_name" => "aodi",
            "acquirer_id" => "1"
          }
        },
        {
          "cmd" => "update",
          "timestamp" => 1_420_070_400_020,
          "fields" => {
            "id" => "1211391233136",
            "styl_name" => "baoma",
            "acquirer_id" => "1"
          }
        }
      ]
    }
  end

  let(:app_name) { ENV.fetch("APP_NAME") }

  context "AliyunOpenSearch::Syncs.new(app_name).execute(params)" do
    it "send request directly" do
      res = AliyunOpenSearch::Syncs.new(app_name).execute(params)

      expect(JSON.load(res.body)["status"]).to eq "OK"
    end
  end
end
