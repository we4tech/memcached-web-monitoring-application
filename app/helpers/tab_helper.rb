module TabHelper

  # render tab from the list of specified tab name and url
  def render_tabs(*p_tabs)
    html = "<ul>"
    p_tabs.each do |tab_info|
      link_class = ""
      link_class = 'selected' if tab_info[:selected]
      if tab_info[:parameter] && (tab_name = params[tab_info[:parameter]])
        if tab_info[:url].match(/\/#{tab_name}$/)
          link_class = 'selected'
        else
          link_class = ''
        end
      end
      html << %{
          <li>
            <a href="#{tab_info[:url]}" title="#{tab_info[:title] || tab_info[:label]}"
               class='#{link_class}'>
              <span>
                <img src="#{tab_info[:icon]}" alt="#{tab_info[:icon_alt]}"/>
                <b>#{tab_info[:label] || tab_info[:title]}</b>
              </span>
            </a>
          </li>
      }
    end
    html << "</ul>"
    return html
  end
end