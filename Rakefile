# -*- coding: utf-8 -*-
require 'yaml'
require "colorize"
require 'command_line/global'

begin
  config = YAML.load(File.read(".hc_config.yaml"))
  p ['config', config]
rescue Errno::ENOENT
  config = {year: 2025,
lecture: "math_ex_ala",
source_html: "math_ex_ala_26s.html"}

  File.write(".hc_config.yaml",YAML.dump(config))
  puts "edit .hc_config.yaml"
  exit
end

$year = config[:year].to_s
$lecture = config[:lecture] #'math_ex_ala'
$source_html = config[:source_html]
$local_dir = File.join('~/Sites/new_ist/Lectures',$year)
$lec_dir = File.expand_path(File.join($local_dir,$lecture))

task :default do
  p ['$lec_dir', $lec_dir]
  p ['$lec_dir', $lec_dir]
  system "rake -T"
end

desc "DIR : make DIR light table" #desc -> description
task :mk_light_table => :show_dirs do # any name on task_name
  comm = "ruby _for_hyper_card/auto_mk_light_table.rb"
  puts comm
  puts "\nFor making light table structured, modify light_table.yaml.".green
  exit
end

desc "show necessary dirs for display light table DIR public." #desc -> description
task :show_dirs do # any name on task_name
  puts "Setup following dirs:".blue
  puts "#{$lec_dir}".blue
  puts "#{$ist_dir}".blue
  puts ""
end

desc "commit local dir" #desc -> description
task :commit => :show_dirs do # any name on task_name
  system "mkdir #{$lec_dir}"
  Dir.glob("c*").each do |s_dir|
    p s_dir
    next unless File.directory?(s_dir)
   # comm = "cp -rf #{s_dir} #{$lec_dir}"
    comm = "rsync -av --exclude=\".*\" #{s_dir} #{$lec_dir}"
    p comm
    system comm
  end
  ["cp #{$source_html} #{$lec_dir}",
   "cp style.css theme.css #{$lec_dir}",
   "chmod -R a+r #{$lec_dir}"
  ].each do |comm|
    p comm
    system comm
  end
  exit
end

desc "push light tables to web server"
task :push => :show_dirs do
  $ist_dir = File.join("nishitani@ist.ksc.kwansei.ac.jp:~/public_html/Lectures",
                       $year)
  $https_dir = File.join("https://ist.ksc.kwansei.ac.jp/~nishitani/Lectures",
                         $year, $lecture, $source_html)
  ["rsync --exclude=\".*\" -auvz -e ssh ~/Sites/new_ist/ nishitani@ist.ksc.kwansei.ac.jp:~/public_html",
   "open #{$https_dir}"].each do |comm|
    puts comm
    system comm
  end
end

desc "mk link from ligh_table.yaml"
task :mk_link do
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
end
