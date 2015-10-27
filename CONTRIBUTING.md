## Welcome!

We're so glad you're thinking about contributing to an 18F open source project! If you're unsure or afraid of anything, just ask or submit the issue or pull request anyways. The worst that can happen is that you'll be politely asked to change something. We appreciate any sort of contribution, and don't want a wall of rules to get in the way of that.

Before contributing, we encourage you to read our CONTRIBUTING policy (you are here), our LICENSE, and our README, all of which should be in this repository. If you have any questions, or want to read more about our underlying policies, you can consult the 18F Open Source Policy GitHub repository at https://github.com/18f/open-source-policy, or just shoot us an email/official government letterhead note to [18f@gsa.gov](mailto:18f@gsa.gov).

## Code Changes

If you are making an improvement to the code that has no impact on the format of the about.yml file itself, then the process is pretty easy.  Fork for repo (or make a branch if you have write access) and make small, focused improvements each in its own pull request.  Pull Requests should be merged by a different person who opened them, ensuring that at least one other person has eyes on it.  If you see an open pull request that you agree with add a comment.  Note that a :+1: -- a :+1: by itself merely indicates that you like the direction and think it is a good idea, if you have reviewed the code or text, please comment that you have done so.  Unless it is a very small change or critical fix, pull requests should remain open for 24 hours to give everyone on the team a chance to chime in.

## Schema Changes

The current schema can be found in the [master branch](https://github.com/18F/about_yml/blob/master/lib/about_yml/schema.json).  We use [semantic versioning](http://semver.org/) to help people using about.yml files to document the format of the file they are writing, which then helps us write tools to consume that data.

If you have an idea for schema change:

1. Create a GitHub issue describing the use case for that change, including whether this changes how a project with this data would appear on the [dashboard](https://github.com/18F/dashboard) and ideas for visual presentation if includes new or different data
2. Create a branch named schema-version.  For example, if we are currently at 1.1, then a schema addition would be schema-1.2 and for field name changes the branch would be called schema-2.0
3. Find 2-3 projects who have a need for this change and mock up what the changes will look like, first in how they would be presented to consumers of the data (typically the visual representation on the dashboard), then the about.yml changes required. Low fidelity mockups such as pencil sketches or text representations are encouraged for initial quick feedback.  This may feel like a lot of work (and it is). We believe that doing this kind of user research is the fastest way to get to an effective solution, allowing us to validate that both technical and visual/interaction design work before shipping production code that relies on it and getting all of our projects to conform to the new change.
  * Drop a note in #dashboard with your idea, then follow-up with sketches, iterate!
  * When team members are excited about the change, show it to some of the people who need the data.  We want to validate the design with both producers and consumers of the data.
4. When 2-3 product/team leads have :+1: your mockup and proposed change (in the github issue) then make the team-api and dashboard support the proposed change.  Note: we maintain backwards-compatibility to at least one prior major version in team-api, and dashboard should gracefully handle projects which include a subset of data.
5. See Code Changes section above for how the code change is reviewed and accepted before merging to master.  

## Public domain

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
