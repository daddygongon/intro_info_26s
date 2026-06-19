require 'yaml'

layer_str = File.read("light_table.yaml")
data = YAML.load(layer_str)

# upをYAMLから取得
up_node = data.find { |node| node.key?(:up) }
up = up_node ? up_node[:up].first[:href] : $source_html
p up

# 'items' を持つ要素のみを対象にし、up を取り除く
hrefs = data.select { |node| node.key?(:items) }.flat_map { |sec| sec[:items].map { |item| item[:href] } }

div = hrefs.size

hrefs.each_with_index do |f, i|
  # 画像ファイルなどが直リンクされている場合はスキップ
  next unless f.end_with?('.html')
  
  p org_file = f.sub(".html", ".org")
  next unless File.exist?(org_file) # orgファイルが存在しない場合はスキップ
  
  layers = f.split('/').size-1
  up_move= '../'*layers
  lines = File.readlines(org_file)
  lines.each_with_index do |line, j|
    lines[j] = "[[#{up_move}#{hrefs[(i-1)%div]}][prev_button]]\n" if line.include?('[prev_button]]')
    lines[j] = "[[#{up_move}#{up}][up_button]]\n" if line.include?('[up_button]]')
    lines[j] = "[[#{up_move}#{hrefs[(i+1)%div]}][next_button]]\n" if line.include?('[next_button]]')
  end
  puts "[[#{up_move}#{hrefs[(i-1)%div]}][prev_button]]
[[#{up_move}#{up}][up_button]]
[[#{up_move}#{hrefs[(i+1)%div]}][next_button]]
"
  File.write(org_file, lines.join(""))
  system "emacs #{org_file} --batch -l ~/.emacs.d/init.el -f org-html-export-to-html --kill"
end
