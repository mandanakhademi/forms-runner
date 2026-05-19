require "rails_helper"

RSpec.describe EmailFormatHelper, type: :helper do
  describe "#normalize_whitespace" do
    it "strips leading/trailing whitespace and collapses multiple blank lines to two newlines" do
      input_text = "  Line1\r\n\r\n\r\nLine2\n\n  Line3  "
      expect(helper.normalize_whitespace(input_text)).to eq("Line1\n\nLine2\n\nLine3")
    end
  end

  describe "#convert_newlines_to_html" do
    it "replaces newlines with <br/>" do
      input_text = "a\nb\n"
      expect(helper.convert_newlines_to_html(input_text)).to eq("a<br/>b<br/>")
    end
  end

  describe "#normalize_whitespace_and_convert_to_html" do
    it "normalizes whitespace then converts newlines to <br/>" do
      input_text = "  Line1\n\n\nLine2  "
      expect(helper.normalize_whitespace_and_convert_to_html(input_text)).to eq("Line1<br/><br/>Line2")
    end
  end
end
