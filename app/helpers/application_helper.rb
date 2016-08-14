module ApplicationHelper
  def link_to_with_icon(icon_css, title, url, options = {})
    icon = content_tag(:i, nil, class: icon_css)
    title_with_icon = icon << ' ' << title
    link_to(title_with_icon, url, options)
  end

  def toggle_button_to(title_on, title_off, url_on, url_off, class_options = {})
    all_options = {
      'data-remote' => true,
      'data-type' => 'script'
    }

    on_options = {
      'data-method' => 'POST',
      class: class_options[:on]
    }.merge(all_options)

    off_options = {
      'data-method' => 'DELETE',
      class: class_options[:off]
    }.merge(all_options)

    on_link = link_to(title_on, url_on, on_options)
    off_link = link_to(title_off, url_off, off_options)

    on_link << off_link
  end

  def modal(title, &block)
    concat render(:partial => 'layouts/modal', :locals => {:title => title, :binding => block})
  end

  def render_tab(tab_constant, url, &block)
    klass = tab_constant == current_tab ? "active" : ""
    content_tag(:li, class: klass) do
      if block_given?
        link_to(raw('<span class="nav-label">' + tab_constant + '</span>'), url) + capture(&block)
      else
        link_to(raw('<span class="nav-label">' + tab_constant + '</span>'), url)
      end
    end
  end

  def drop_down_button(actions, addclass = nil)
    content_tag(:div, class: "dropdown #{addclass}") do
      full_content = content_tag(:button, data: {toggle: "dropdown"}, class: "dropdown-toggle btn-white") do
        content_tag(:i, class: "fa fa-angle-down") do
        end
      end
      full_content += content_tag(:ul, class: "dropdown-menu m-t-xs") do 
        sub_links = ""
        actions.each do |ac|
          sub_links += content_tag(:li, ac)
        end
        raw sub_links
      end
      full_content
    end
  end

  def full_drop_down_button(content, klass, actions)
    content_tag(:div, class: "btn-group btn-group-xs", title: content) do
      full_content = content_tag(:button, data: {toggle: "dropdown"}, class: "btn #{klass} dropdown-toggle") do
        content_tag(:span, content.chars[0])
      end

      full_content += content_tag(:ul, class: "dropdown-menu") do 
        sub_links = ""
        actions.each do |ac|
          sub_links += content_tag(:li, ac)
        end
        raw sub_links
      end

      full_content
    end
    
  end
end
