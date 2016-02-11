# `.about.yml` schema and tools

The `.about.yml` mechanism allows a project to publish and maintain metadata
that can be easily maintained by project owners, that is visible and
accessible to interested parties, and that can be harvested and processed by
tools and automated systems. It is implemented using the
[YAML](https://en.wikipedia.org/wiki/YAML) format.

The [18F Team API](https://team-api.18f.gov/public/api/) is the original,
primary consumer of this information, which in turn provides data for:

- [18F Hub](https://github.com/18F/hub)
- [18F Dashboard](https://github.com/18F/dashboard)
- [18F.gsa.gov](https://github.com/18F/18f.gsa.gov)

We hope that every active 18F project, [working
group](https://pages.18f.gov/grouplet-playbook/working-groups/), and
[guild](https://pages.18f.gov/grouplet-playbook/guilds/) will publish
`.about.yml` files in their respective repositories. By feeding this
information through the Team API server and into our Hub, Dashboard, and main
web site, cultivation of `.about.yml` files will help make our activity more
easily transparent to our teammates, and to anyone outside our team who wishes
to discover what we're working on (and how we work).

## Quick start

Copy the [`template.yml`](./template.yml) file from this repository into the
root directory of your project's repository as `.about.yml`. Then refer to the
[cheat sheet](#cheat-sheet) for instructions regarding how to fill in the
data.

## Installation

Run `gem install about_yml` on the command line. You can also add `gem
'about_yml'` to your project's `Gemfile` if you use
[Bundler](http://bundler.io/) and wish to configure the `about_yml_validate`
program as a pre-commit check.

## Usage

Most users will interact with the gem through one of the following
command-line programs.

### `about_yml_generate`

This program will generate an empty `.about.yml` template with descriptions of
each field. To add a new `.about.yml` file to your project where `MY-PROJECT`
is the path to your local clone of your project's repository:

```shell
$ about_yml_generate > MY-PROJECT/.about.yml
```

### `about_yml_validate`

This program checks one or more `.about.yml` files against the `.about.yml`
schema. To check your project's `.about.yml` file:

```shell
$ about_yml_validate MY-PROJECT/.about.yml
```

Alternatively, you can add the following to your `Rakefile` to tie
`.about.yml` validation into your build process (this assumes that `Rakefile`
and `.about.yml` are both in the top-level project directory):

```ruby
# Development-only tasks
begin
  require 'about_yml/tasks/check_about_yml'
  task test: :run_about_yml_check
rescue LoadError
end
```

### `about_yml_scrape`

This program checks for an `.about.yml` file in every GitHub repository
belonging to a specified organization, then downloads, validates, and
categorizes all of the discovered files into a single YAML object. You must
have a valid
[GitHub API token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)
to run this command.

```shell
$ about_yml_scrape 18F > 18F_about_yml_data.yml
```

### `github_org_descriptions`

This program doesn't have anything to do with the `.about.yml` schema, but is
a small, handy program that also uses the
[`octokit`](https://rubygems.org/gems/octokit) gem to access the GitHub API.
It will return a YAML list of names and descriptions for all of the
repositories belonging to an organization.

## `.about.yml` file testing

The `run_about_yml_check` Rake task provides a relatively simple way to check
a project's `.about.yml` file for errors.

### Add the task to your Rakefile

To test whether the `.about.yml` file for a repository will successfully parse
based on the schema, simply include the `about_yml` gem in your dependencies and
then load the task in your Rakefile:

```ruby
check_yml = Gem::Specification.find_by_name 'about_yml'
load "#{check_yml.gem_dir}/lib/about_yml/tasks/check_about_yml.rake"
```

If your project already include `about_yml`, make sure it is using version 0.0.8
or later.

### Run the task automatically with Travis

To run the `run_about_yml_check` task automatically using Travis, simply add
the following to your `.travis.yml` config file (with any preferred
notifications):

```yml
script: bundle exec rake run_about_yml_check
```


## <a name="cheat-sheet"></a>`.about.yml` cheat sheet
The following attributes are currently stored in the `.about.yml` file and are used in one or more of the locations referenced above. Required attributes are marked with an asterisk, and field descriptions and examples follow each attribute. Take a look at [Every Kid in a Park](https://github.com/18F/ekip-api/blob/master/.about.yml) or [Open Opportunities](https://github.com/18F/openopps-platform/blob/dev/.about.yml) for living examples of `.about.yml` in action.


`name`* - This is a short name of your project that is used as a URL slug on the 18F dashboard.
> 
```yml
name: ekip-api
```

`full_name`* - This is the display name of your project on the 18F dashboard.
> 
```yml
full_name: Every Kid in a Park
```

`description`* - What is the problem your project solves? What is the solution? Use the format shown below. The #dashboard team will gladly help you put this together for your project. 
> 
```yml
description: |
  In 2015, President Obama formally announced the Every Kid in a Park program, which provides 
  fourth graders and their families with free access to more than 2,000 federally managed sites. 
  18F worked with the Department of the Interior to create the program’s website, which was 
  written at a fourth grade level with the help of fourth graders.
```

`impact`* - What is the measurable impact of your project? Use the format shown below. The #dashboard team will gladly help you put this together for your project.
> 
```yml
impact: |
  We designed a website that gives fourth graders and their families free access to more than 2,000 
  federally-managed sites.
```

`owner_type`* - What kind of team owns the repository? *Accepted values: guild, working-group, project*
> 
```yml
owner_type: project
```

`stage`* - What is your project's current status? *Accepted values: discovery, alpha, beta, live*
>
```yml
stage: live
```

`testable`* - Should this repo have automated tests? If so, set to `true`. *Accepted values: true, false*
>
```yml
testable: true
```

`licenses`* - What are the licences that apply to the project and/or its components? Get the license name from the [Software Package Data Exchange (SPDX)] (https://spdx.org/licenses/)
>
```yml
licenses:
  ekip-api:
    name: CC0-1.0
    url: https://github.com/18F/team_api/blob/master/LICENSE.md
```

`partners` - Who is the parter for your project? (Use the full name of the partner documented  [here](https://github.com/18F/dashboard/blob/staging/_data/partners.yml))
>
```yml
partners:
- U.S. Department of the Interior
```

`contact` - The main point of contact(s) for your project, and a `mailto:` link for that contact.
>
```yml
contact:
- url: mailto:shashank.khandelwal@gsa.gov
  text: Shashank Khandelwal
```

`team` - Who are the team members on your project? For each team member, list a github name, role and an internal identifier. (The project lead role should be `lead`)
>
```yml
team:
- github: khandelwal
  role: lead
  id: khandelwal
```

`milestones` - What are the key milestones you've achieved recently?
>
```yml
milestones:
- "December 2015: Discovery completed"
```

`type` - What kind of content is contained in the project repository? *Accepted values: app, docs, policy*
> 
```yml
type: app
```

`parent` - Name of the main project repo if this is a sub-repo; name of the working group/guild repo if this is a working group/guild subproject
> 
```yml
parent: [GitHub repo name]
```

`links` - What are the key links associated with your project?
> 
```yml
links:
- url: everykidinapark.gov
  text: Every Kid in a Park
```

`blogTag` - What is the 18F blog tag for your project? You can find a list of tags [here](https://18f.gsa.gov/tags/)
> 
```yml
blogTag: [18F Blog Tag]
```

`stack` - What technologies are used in this project?
>
```yml
stack:
- Django
```

`services` - What are the services used to supply project status information?
>
```yml
services:
- name: Coveralls
  category: Build review
  url: https://coveralls.io/github/18F/ekip-api?branch=master
  badge: https://coveralls.io/repos/18F/ekip-api/badge.svg?branch=master&service=github
- name: Quantified Code
  category: Site review
  url: https://www.quantifiedcode.com/app/project/ecb305ac0bfa4e968192621402faface
  badge: https://www.quantifiedcode.com/api/v1/project/ecb305ac0bfa4e968192621402faface/badge.svg
```

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0
>dedication. By submitting a pull request, you are agreeing to comply
>with this waiver of copyright interest.
