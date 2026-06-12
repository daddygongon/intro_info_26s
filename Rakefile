# -*- coding: utf-8 -*-
require 'yaml'
require "colorize"
require 'command_line/global'

begin
  config = YAML.load(File.read(".hc_config.yaml"))
  p ['config', config]
rescue Errno::ENOENT
  config = {year: 2026,
 lecture: "intro_info",
 source_html: "intro_info_26s.html",
 glob_extensions: "c*/*.html",
 server_info:
  {local_sites: "~/Sites/new_ist/Lectures",
   ruby_code_dir: "c0_mk_stack_dir",
   server_ssh_path: "nishitani@ist.ksc.kwansei.ac.jp:~/public_html",
   server_url: "https://ist.ksc.kwansei.ac.jp/~nishitani/Lectures"}}

  File.write(".hc_config.yaml",YAML.dump(config))
  puts "edit .hc_config.yaml"
  exit
end

$year = config[:year].to_s
$lecture = config[:lecture] ||'intro_info'
$source_html = config[:source_html]

server_info = config[:server_info] || {}
$local_sites = server_info[:local_sites] || "~/Sites/new_ist/Lectures"
$ruby_code_dir = server_info[:ruby_code_dir] || "c0_mk_stack_dir"
$server_ssh_path = server_info[:server_ssh_path] || "nishitani@ist.ksc.kwansei.ac.jp:~/public_html"
$server_url = server_info[:server_url] || "https://ist.ksc.kwansei.ac.jp/~nishitani/Lectures"

$local_dir = File.join($local_sites, $year)
$lec_dir = File.expand_path(File.join($local_dir,$lecture))
$glob_extensions = config[:glob_extensions] || "c*/*.html"

task :default do
  p ['$lec_dir', $lec_dir]
  p ['$lec_dir', $lec_dir]
  system "rake -T"
end

desc "show files for markup list"
task :ls do
  Dir.chdir(Rake.application.original_dir) do
    Dir.glob("./*").each do |file|
      if File.symlink?(file)
        symlink_path = File.readlink(file)
        puts "- [[#{symlink_path}][#{file}]](symlink)"
      elsif File.directory?(file)
        next
      else
        puts "- [[file:#{file}][#{file}]]"
      end
    end
  end
end

desc "mk new sub directory"
task :mkdir do
  hp = File.join($ruby_code_dir, 'templates')
  dir_name = ARGV[1] || 'new_sub_dir'
  ["mkdir #{dir_name}",
   "cp #{File.join(hp,'readme.org')} #{dir_name}",
   "cp #{File.join(hp,'dummy_icon.png')} #{dir_name}",
   "cp #{File.join(hp,'style_w_link_button.css')} #{dir_name}"
  ].each do |comm|
    puts comm
    system comm
  end
end

desc "DIR : make DIR light table" #desc -> description
task :mk_light_table => :show_dirs do # any name on task_name
  comm = "ruby #{File.join($ruby_code_dir, 'auto_mk_light_table.rb')}"
  puts comm
  puts "\nFor making light table structured, modify light_table.yaml.".green
  exit
end

desc "show dirs for display light table DIR public." #desc -> description
task :show_dirs do # any name on task_name
  puts "Setup following dirs:".blue
  puts "#{$lec_dir}".blue
  puts "#{$ist_dir}".blue
  puts ""
end

desc "commit local dir" #desc -> description
task :commit => :show_dirs do # any name on task_name
  system "mkdir #{$lec_dir}"
  
  excludes = %w[.venv/ venv/ env/ .env/ __pycache__/ .git/]
  exclude_opts = excludes.map { |e| "--exclude=\"#{e}\"" }.join(" ")

  Dir.glob($glob_extensions.split('/').first).each do |s_dir|
    p s_dir
    next unless File.directory?(s_dir)
   # comm = "cp -rf #{s_dir} #{$lec_dir}"
    comm = "rsync -av #{exclude_opts} #{s_dir} #{$lec_dir}"
    puts comm.blue
    system comm
  end
  ["cp #{$source_html} #{$lec_dir}",
   "cp style.css theme.css #{$lec_dir}",
   "chmod -R a+r #{$lec_dir}"
  ].each do |comm|
    puts comm.blue
    system comm
  end
  exit
end

desc "push light tables to web server"
task :push => :show_dirs do
  https_dir = File.join($server_url,
                         $year, $lecture, $source_html)
  local_base_dir = File.join($local_sites, $year)
  ["rsync -F -auvz -e ssh #{local_base_dir} #{$server_ssh_path}/Lectures",
   "open #{https_dir}"].each do |comm|
    puts comm.blue
    system comm
  end
end

desc "mk link from ligh_table.yaml"
task :mk_link do
  comm = "ruby #{File.join($ruby_code_dir, 'mk_link.rb')}"
  puts comm.blue
  puts "\nFor making links for up, prev, next buttons from light_table.yaml.".green
  exit
  
end
