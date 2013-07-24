require "spec_helper"

describe Mailer do
  describe "share" do
    let(:mail) { Mailer.share }

    it "renders the headers" do
      mail.subject.should eq("Share")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
