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

desc "mk new sub directory"
task :mk_new_sub_dir do
  hp = '_for_hyper_card'
  dir_name = 'new_sub_dir'
  ["mkdir #{dir_name}",
   "cp #{File.join(hp,'intro_info.001.png')} #{dir_name}",
   "cp #{File.join(hp,'readme.org')} #{dir_name}",
   "cp #{File.join(hp,'style_w_link_button_one_column.css')} #{dir_name}/style.css"
  ].each do |comm|
    puts comm
    system comm
  end
end

desc "DIR : make DIR light table" #desc -> description
task :mk_light_table => :show_dirs do # any name on task_name
  comm = "ruby c0_mk_stack_dir/auto_mk_light_table.rb"
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
  comm = "ruby c0_mk_stack_dir/mk_link.rb"
  puts comm
  puts "\nFor making links for up, prev, next buttons from light_table.yaml.".green
  exit
  
end
