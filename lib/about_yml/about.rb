require 'base64'
require 'json'
require 'json-schema'
require 'octokit'
require 'safe_yaml'

SafeYAML::OPTIONS[:default_mode] = :safe
Octokit.auto_paginate = true

module AboutYml
  class AboutFile
    def self.schema
      @schema ||= begin
        raw_schema = File.read File.join(File.dirname(__FILE__), 'schema.json')
        schema = ::JSON.parse raw_schema
        ::JSON::Validator.fully_validate_schema schema
        schema
      end
    end

    def self.fetch_from_github(github_org, access_key)
      client = Octokit::Client.new access_token: access_key
      repos = client.org_repos github_org
      result = {
        'public' => {},
        'private' => {},
        'missing' => [],
        'errors' => {},
      }
      repos.each { |repo| collect_repository_data repo, client, result }
      result
    end

    def self.fetch_file_contents(client, repo_full_name)
      about = client.contents repo_full_name, path: '.about.yml'
      SafeYAML.load Base64.decode64(about['content'])
    end

    def self.write_error(err, repo, result)
      $stderr.puts('Error while parsing .about.yml for ' \
        "#{repo.full_name}:\n #{err}")
      result['errors'][repo.full_name] = err.message
    end

    def self.add_github_metadata(result, repo)
      result['github'] = {
        'name' => repo.full_name,
        'description' => repo.description,
      }
    end

    def self.collect_repository_data(repo, client, result)
      collection = (repo.private == true) ? 'private' : 'public'
      repo_name = repo.full_name
      result[collection][repo_name] = fetch_file_contents client, repo_name
      add_github_metadata result[collection][repo_name], repo
    rescue Octokit::NotFound
      result['missing'] << repo.full_name
    rescue StandardError => err
      write_error err, repo, result
    end
    private_class_method :collect_repository_data

    def self.validate_single_file(about_data)
      ::JSON::Validator.fully_validate schema, about_data
    end

    def self.validate_about_files(repo_name_to_about_data)
      r = { 'valid' => {}, 'invalid' => {} }
      repo_name_to_about_data.each_with_object(r) do |data, results|
        repo, contents = data
        errors = validate_single_file contents
        if errors.empty?
          results['valid'][repo] = contents
        else
          results['invalid'][repo] = { errors: errors, contents: contents }
        end
      end
    end

    def self.organize_by_owner_type_and_name(abouts)
      abouts.values.each_with_object({}) do |about, result|
        owner_type = about['owner_type']
        name = about['name']
        if owner_type && name
          (result[owner_type] ||= {})[name] = about
        else
          alt_id = about['full_name'] ? about['full_name'] : about['name']
          result[alt_id + '/' + about['type']] = about
        end
      end
    end
  end
end
