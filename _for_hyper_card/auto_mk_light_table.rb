require 'yaml'

begin
    config = YAML.load_file(".hc_config.yaml")
rescue Errno::ENOENT
    abort "Error: .hc_config.yaml を開けませんでした。"
end

data = [
    { up: [{ href: config[:source_html], title: config[:lecture] }] }
]
pp data

glob_extensions = config[:glob_extensions] || "c*/*.html"

Dir.glob(glob_extensions).each_with_index do |file, index|
    if index % 3 == 0
        data << {
            id: "section-#{index / 3}",
            title: "セクション #{index / 3}",
            items: []
        }
    end

    html_text = File.read(file)
    title_match = html_text.match(/<title>(.*?)<\/title>/m)
    page_title = title_match ? title_match[1].strip : nil

    img_matches = html_text.scan(/<img[^>]+src="([^"]+)"/i)
    page_img_src = img_matches.any? ? File.join(File.dirname(file), img_matches.last.first.sub(/\A\.\//, '')) : nil

    data.find { |section| section[:id] == "section-#{index / 3}" }[:items] << {
        href: file, 
        src: page_img_src,
        title: page_title
}
end

File.write("light_table.yaml", YAML.dump(data))
