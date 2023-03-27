module Jekyll
    class RenderFullWidthTag < Liquid::Tag
        require "shellwords"
        require "kramdown"

        def initialize(tag_name, text, token)
            super 
            @text = text.shellsplit
        end
        def render(context)
         #gather setting
            site = context.registers[:site]
            converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
            baseurl = context.registers[:site].config['baseurl']
            label = Kramdown::Document.new(@text[1]. remove_span_html_tags:true).to_html #render markdown in caption
            label = convert.convert(label).gsub(/<\/?p[^>]*>/,"").chomp #remove <p> tags from render

            if @text[0].starts_with?('http://','https://','//')
                "<figure class='fullwidth'><img src='#{@text[0]}'/>"+
                "<figcaption>#{label}</figcaption></figure>"
            else
                "<figure class='fullwidth'><img src='#{baseurl}/#{@text[0]}'/>"+
                "<figcaption>#{label}</figcaption></figure>"
            end
        end
    end
end
    
Liquid::Template.register_tag('fullwidth', Jekyll::RenderFullWidthTag)