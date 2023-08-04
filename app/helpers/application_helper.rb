module ApplicationHelper
  def default_meta_tags
    {
      site: Site.title,
      reverse: false,
      charset: 'utf-8',
      description: Site.description,
      canonical: request.original_url,
      separator: '｜',
      icon: [
        { href: "#{Site.origin}/favicon.ico" },
      ],
      og: {
        site_name: :site,
        title: :site,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: "#{Site.origin}/ogp.png",
        local: 'ja-JP',
      },
      twitter: {
        card: 'summary_large_image',
        image: "#{Site.origin}/ogp.png",
      }
    }
  end

  def primary_button_class
    "rounded-sm px-2 py-1 shadow-sm text-white bg-sky-500 font-bold hover:bg-sky-600 transition-all disabled:opacity-30 cursor-pointer text-sm"
  end

  def label_class
    "block text-gray-700 text-sm font-bold mb-2"
  end

  def text_field_class
    "block rounded w-full px-3 py-2 border text-gray-700 hover:bg-gray-100 transition-all dark:bg-[rgb(30,39,50)] dark:border dark:border-[#30363d] dark:text-[#eee] dark:hover:bg-[rgb(30,39,50)] dark:hover:border-[#30363d]"
  end

  def loading_box_class
    "h-48 shadow-sm w-full bg-gray-100 duration-75 border-b animate-pulse transition"
  end

  def nav_class
    "w-full mb-4 flex text-sm items-center border-b dark:border-slate-600"
  end

  def nav_item_class(path, width)
    "hover:bg-gray-100 dark:hover:bg-[rgb(30,39,50)] py-2 #{width} text-center #{request.path == path ? "font-bold border-b-2 border-sky-500" : ""}"
  end

  def card_class
    "shadow-sm mb-4 rounded-lg relative bg-white dark p-4 dark:text-[#ddd] dark:bg-[rgb(30,39,50)] dark:border dark:border-[#30363d] dark:text-[#eee]"
  end

  def block_link_class
    "py-1 px-2 block hover:bg-gray-50 rounded dark:hover:bg-gray-700 transition-all"
  end

  def icon_button_class
    "block rounded-full cursor-pointer p-relative p-2 hover:bg-gray-50 transition-all dark:hover:bg-gray-700"
  end

  def should_render_sidebar?
    !request.path.match?(/users/)
  end
end
