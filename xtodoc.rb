require "file_utils"
def makeindex(output, dir)
  files = Dir["#{dir}/**"]
  puts "dir + #{dir}"
  puts "files + #{files}"
  output.puts
  files.each do |file|
    if !File.directory?(file)
      output.puts("./[#{File.basename(file, File.extname(file))}](./#{File.basename(file, File.extname(file))}.html)")
    else
      output.puts("./[#{File.basename(file, File.extname(file))}](./#{File.basename(file, File.extname(file))}/index.html)")
    end
    output.puts
  end
end

def image?(file)
  file.to_s.includes?(".gif") || file.to_s.includes?(".png") || file.to_s.includes?(".jpg")
end


def begin_file(file, output_file)
  output_file.puts("---")
  output_file.puts("title: #{File.basename(file)}")
  output_file.puts("---")
end

def nix(file, output_file, file_extension)
  begin_file(file, output_file)
  code = true
  input_file = File.open(file)
  file_lines = input_file.read_line
  if file_lines.chomp == "/*"
    puts "Found comment at beggining of file" + file
  else
    puts file + "Added extension at begin"
    output_file.puts("```#{file_extension}")
  end
  input_file.each_line do |line|
    if line.chomp.lstrip.starts_with? "/*"
      code = false
      output_file.puts("```")
    elsif line.chomp.lstrip.starts_with? "*/"
      code = true
      output_file.puts("```#{file_extension}")
    else
      if code == true
        output_file.puts(line)
      else
        output_file.puts(line.lstrip)
      end
    end
  end
  output_file.puts("```")
  output_file.close
end

def md(file, output_file)
  begin_file(file, output_file)
  File.open(file).each_line do |line|
    output_file.puts(line)
  end
  output_file.close
end

def other(file, output_file)
  begin_file(file, output_file)
  output_file.puts("```")
  File.open(file).each_line do |line|
    output_file.puts(line)
  end
  output_file.puts("```")
  output_file.close
end

def mdfile(file, output_dir)
  case File.extname(file).delete(".")
  when "nix"
    nix(file, File.new("#{output_dir}/#{file}.md", "w"), "nix")
  when "md"
    md(file, File.new("#{output_dir}/#{file}", "w"))
  else
    other(file, File.new("#{output_dir}/#{file}.md", "w"))
  end
end

# config = TOML::Parser.new(File.open("./xtodoc.toml").read).parsed
OUTPUT_DIR = "docs/"
`rm -rf #{OUTPUT_DIR}`
resource_paths = Dir.glob("**/*").reject do |path|
  File.directory?(path) || path.ends_with?("index.md") || image?(path)
end
images = Dir.glob("**/*").select do |path|
  image?(path)
end
directories = Dir.glob("**/*").select do |path|
  File.directory?(path) & (path != OUTPUT_DIR)
end
# FileUtils.mkpath OUTPUT_DIR
`mkdir #{OUTPUT_DIR}`
directories.each do |dir|
  # FileUtils.mkpath "#{OUTPUT_DIR}/#{dir}"
  mkcommand = "mkdir #{OUTPUT_DIR}/#{dir}"
  `#{mkcommand}`
end
resource_paths.each do |file|
  mdfile(file, OUTPUT_DIR)
end
directories.each do |dir|
  index = File.new("#{OUTPUT_DIR}/#{dir}/index.md", "w")
  begin_file(dir, index)
  if File.exists?("#{dir}/index.md")
    File.open("#{dir}/index.md").each_line do |output|
      index.puts(output)
    end
  end
  makeindex(index, "#{OUTPUT_DIR}#{dir}")
  index.close
end
index = File.open("#{OUTPUT_DIR}/index.md", "w")
begin_file(OUTPUT_DIR.to_s, index)
File.open("./index.md").each_line do |output|
  index.puts(output)
end
makeindex(index, OUTPUT_DIR.to_s)
images.each do |image|
  FileUtils.cp(image, "./docs/#{image}")
end
index.close
resource_paths_html = Dir["./docs/**/*"].reject do |path|
  File.directory?(path) || image?(path)
end

resource_paths_html.each do |file|
  output_file_path = file[0..-4]
  puts output_file_path
  command = "pandoc -s #{file} -o #{output_file_path}.html --highlight-style=./theme/dracula/dracula.theme --css=./theme/wizardwatch.css --self-contained -H ./theme/header.html --lua-filter ./theme/root.lua"
  `#{command}`
  `rm #{file}`
end
