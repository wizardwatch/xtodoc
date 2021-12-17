```rb#! /usr/bin/env ruby
```
  # About
  xtodoc takes in commented files and outputs them in markdown. Markdown formatting used
  within the code is respected.

  # Why?
  I wrote xtodoc to generate documentation for my NixOS configuration. Since more than
  nix code is used xtodoc had to be able to generate documentation for many
  languages.
  ## Why not Org files?
  I don't personally always use Emacs (this was typed in Neovim) and I didn't want I nor
  anyone else to depend on it for editing any code.

  # License
  This code is licensed under AGPL.
```rb
require 'pathname'
require 'fileutils'
def top_parent_dir(path)
  Pathname.new(path).each_filename.to_a[0]
end
def mdfile(file, output_dir)
  file_extension = File.extname(file).delete('.')
  file_name = file[0..file.length - (file_extension.length + 2)]
  output_file = File.new("#{output_dir}/#{file_name}.md", 'w')
  output_file.write("```#{file_extension}")
  case file_extension
  when 'nix'
    openers = ['/*']
    closers = ['*/']
  when 'rb'
    openers = ['=begin']
    closers = ['=end']
  end
  File.open(file).each_line do |line|
    if openers.any? { |x| line.chomp.start_with? x }
      output_file.puts('```')
    elsif closers.any? { |x| line.chomp.start_with? x }
      output_file.puts("```#{file_extension}")
    else
      output_file.write(line)
    end
  end
  output_file.puts('```')
end

# input = ARGV
# kcase input.first
# when 'md'
#   mdfile(input[1])
# end

OUTPUT_DIR = 'docs'
resource_paths = Dir.glob('**/*').reject do |path|
  top_parent_dir(path) == OUTPUT_DIR || File.directory?(path)
end
print resource_paths
puts

if Pathname.new(OUTPUT_DIR).exist?
  FileUtils.remove_dir OUTPUT_DIR
end
directories = Dir.glob('**/*').select do |path|
  puts File.file?(path)
  File.directory?(path) and path != OUTPUT_DIR
end
print directories
puts
FileUtils.mkpath OUTPUT_DIR
for dir in directories
  FileUtils.mkpath "#{OUTPUT_DIR}/#{dir}"
end
for file in resource_paths
  mdfile(file, OUTPUT_DIR)
end
```
