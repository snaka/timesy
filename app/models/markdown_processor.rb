require "coderay"

class MarkdownProcessor
  VERSION = "202308142311"

  def self.processor
    Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(
        filter_html: true,
        hard_wrap: true,
      ),
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true,
      no_intra_emphasis: true,
      space_after_headers: true,
    )
  end

  def self.process(markdown, length = false)
    Rails.cache.fetch("/markdown/#{VERSION}/#{Digest::SHA256.hexdigest(markdown)}", expires_in: 1.week) do
      markdown = Truncate.process(markdown, length)
      markdown = Emoji::Shortcode.process(markdown)
      html = processor.render(markdown)
      html = Code.process(html)
      html = Link.process(html)
      html = Ogp.process(html)
      html = Emoji::Html.process(html)
      html = ProjectTag.process(html)
      html
    end
  end
end
