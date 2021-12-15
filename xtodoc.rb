#! /usr/bin/env ruby
=begin
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
=end
def mdfile(file)
  file_extension = File.extname(file).delete('.')
  file_name = file[0..file.length - (file_extension.length + 2)]
  output_file = File.new("#{file_name}.md", 'w')
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
input = ARGV
case input.first
when 'md'
  mdfile(input[1])
end
