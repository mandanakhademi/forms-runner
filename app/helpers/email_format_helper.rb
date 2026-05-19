module EmailFormatHelper
  def normalize_whitespace(text)
    text.strip.gsub(/\r\n?/, "\n").split(/\n\n+/).map(&:strip).join("\n\n")
  end

  def convert_newlines_to_html(text)
    text.gsub("\n", "<br/>")
  end

  def normalize_whitespace_and_convert_to_html(text)
    output = normalize_whitespace(text)
    convert_newlines_to_html(output)
  end
end
