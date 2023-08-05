require "coderay"

module Markdownable
  extend ActiveSupport::Concern
  include ActionView::Helpers::SanitizeHelper

  def truncated(length = 64)
    strip_tags(html).gsub(/\n/, " ").gsub(/\//, "").truncate(length)
  end

  def html(truncate = false)
    markdown = Redcarpet::Markdown.new(
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
    if truncate === false
      body = emojified_body
    else
      body = emojified_body.truncate(truncate)
    end
    doc = Nokogiri::HTML::DocumentFragment.parse(markdown.render(body))
    doc.css('code[@class]').each do |code|
      code[:class] = "language-" + code[:class]
    end
    doc.css('a').each do |link|
      link["data-turbo"] = false
    end
    doc.css('p').each do |paragraph|
      if paragraph.children.any? { |child| child.name == "a" }
        link = paragraph.children.find { |child| child.name == "a" }
        if link.text == link["href"]
          data = Rails.cache.fetch("/ogp/#{Digest::SHA256.hexdigest(link.text)}", expires_in: 1.week) do
            response = Faraday.get(link.text)
            ogp = OGP::OpenGraph.new(response.body)
            ogp.data
          rescue
            false
          end
          if data
            link.replace(ApplicationController.renderer.render(partial: "shared/link_card", locals: { ogp: Ogp.new(data) }))
          end
        end
      end
    end
    doc = wrap_emoji(doc.to_s)
    doc = wrap_project_tag(doc)
    doc
  end

  def emojified_body
    return "" if body.nil?
    body.gsub(/:(.*):/) do
      ::Emoji.find_by_alias($1) ? ::Emoji.find_by_alias($1).raw : $&
    end
  end

  def emoji_only?
    emojis = emojified_body.scan(Unicode::Emoji::REGEX)
    emojis.join == emojified_body.chomp
  end

  def wrap_emoji(string)
    string.gsub(Unicode::Emoji::REGEX) do |match|
      if emoji = Emoji.find_by_unicode(match)
        %(<span class="emoji" title="#{emoji.name}">#{match}</span>)
      else
        match
      end
    end
  end

  def wrap_project_tag(string)
    string.gsub(/#(\w+)/) do |match|
      if project = Project.find_by(codename: $1)
        %(<a href="/#{project.user.username}/projects/#{project.codename}" data-controller="tooltip" data-tooltip-text-value="#{project.title} @#{project.user.username}" data-turbo="false" class="project-tag">#{$&}</a>)
      else
        match
      end
    end
  end
end
