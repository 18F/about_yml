require 'about_yml'
require 'safe_yaml'

desc 'Check your .about.yml file'
task :run_about_yml_check do
  project_dir = Rake.original_dir
  about_file = File.join project_dir, '.about.yml'
  unless File.exist? about_file
    $stderr.puts "No .about.yml file found in #{project_dir}"
    exit 1
  end

  about_data = SafeYAML.load_file about_file, safe: true
  errors = ::AboutYml::AboutFile.validate_single_file about_data
  unless errors.empty?
    $stderr.puts(".about.yml contains the following validation errors:\n  " +
      "#{errors.join("\n  ")}")
    exit 1
  end
end
