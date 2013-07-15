module PostsHelper
  def tag_list(tags)
    capture_haml do
      tags.each do |tag|
        haml_tag(:span, tag, class: "label label-info")
      end
    end
  end
end
