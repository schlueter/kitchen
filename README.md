# Schlueter's kitchen (for Chef) #
This project contains all of the Chef code that I use for anything and will grow as I use chef on more projects.

## Using this in a Project ##
I suggest adding the kitchen to any project managed by vagrant (or with chef in some other fashion, though I will primarily discuss usage with vagrant) with git's subtree functionality. To do this, add this repository as a remote to the project (yes, I know, none of the files match up, but bear with me). Fetch—**_do not pull_**–the new remote. Then, especially if you potentially want to contribute back to this repo, checkout a branch from this repo. Git will go into a 'detached HEAD' state, and you now need to create a new branch in the current project to track the current state of the kitchen with a `git checkout -b <new branch>. Once you have kitchen in a new branch, checkout master, or any other branch from your project proper, and read-tree the kitchen branch into it. You'll need to be in the root of your repo for the read-tree command. The git commands would look something like:

    $ git remote add kitchen git@github.com:schlueter/kitchen.git
    $ git fetch kitchen
    $ git checkout kitchen/v0.0.1 # use one of this kitchen's versioned branches for stable code
    $ git checkout -b kitchen
    $ git checkout master
    $ git read-tree --prefix vagrant/kitchen -u kitchen

This will add the contents of the kitchen branch to the current branch under the folder specified with the `--prefix` argument. You can then commit to add the kitchen to begin tracking the kitchen. 

Git's subtree functionality is awesome, and you can move changes from your project's branches to the kitchen branch and vice versa; git does some magic to keep track of all that.

I'll discuss how to use this repository with Vagrant [below](#usage_with_vagrant)

## Layout ##
The folders in this repo each contain Chef related files/folders with different purposes. Currently the structure looks something like this:

    kitchen/
        cookbooks/
            apt/
                ...
            ...
        site-cookbooks/
            android_dev/
                ...
            ...
        roles/
            android-dev.rb
            ...
        config/
            ssl_fix
            ...


### data_bags/ ###
There is one other folder that I add to my kitchens as needed, which is ignored via a .gitignore file in the root of the kitchen repo. That's a `data_bags` folder, which can contain specific, frequently sensitive—and thus the lack of being in a public github repo—configuration information. You can read more about how databags can be used [with Vagrant](http://docs.vagrantup.com/v2/provisioning/chef_solo.html) and [with Chef generally](http://docs.opscode.com/essentials_data_bags.html).

### cookbooks/ ###
Of the folders that *are* included in this kitchen repo, no files should ever be manually changed in one, the `cookbooks` folder. This directory contains only cookbooks which are retrieved from elsewhere (Opscode official cookbooks; random cookbooks on github; random cookbooks that were somehow not in one of the previous two categories; etc.), and have been added to this repo via some method, maintaining their consistency (git subtree or manually adding of an archived cookbook). In the future I may include these as submodules, since they won't change often, and regardless of their original method of source control, can always have git repositories created for them. I accept pull requests for any of these cookbooks, and will either ask that any changes be moved to the site-cookbooks directory, or suggest that a pull request or equivalent be made to the source repository.

### site-cookbooks/ ###
As I just implied, the `site-cookbooks` directory should be used to override cookbooks in the `cookbooks` directory. It should also be used for custom cookbooks either for specific projects, or for specific types of projects. 

### roles/ ###
The `roles` directory's use is for (guess what?) [*roles*](http://docs.opscode.com/essentials_roles.html). These should include any [run-list](http://docs.opscode.com/essentials_node_object_run_lists.html), or role specific custom json. Before I implemented this repository, and also as required with previous versions of Chef and Vagrant, both of these tasks were implemented in a project's Vagrantfile directly with the `chef.add_recipe` (or `chef.run_list`) and `chef.json` methods. This repository *can* be used with those methods, but not using them aids in seperation of concerns, so that the Vagrantfile just contains configuration pertinent to Vagrant, and everything pertinent to Chef is contained here.

## Usage with Vagrant ##
The way that I use this repository with Vagrant involves just a few simple methods in the `:chef_solo` block in a project's Vagrantfile:

    chef.cookbooks_path = %w{ kitchen/cookbooks kitchen/site-cookbooks }

Sets up the cookbooks directories to be used during provisioning runs. It assumes that this repository was included in the project in a `kitchen` folder in the same directory as the `Vagrantfile`.

    chef.roles_path     = 'kitchen/roles'
    chef.data_bags_path = 'kitchen/data_bags'

Sets up the `roles` and `data_bags` folders to be used during provisioning runs with the same assumption as the cookbooks.

    chef.custom_config_path = 'kitchen/config/ssl_fix'

Adds the contents of the ssl_fix file to the config file used during provisioning runs. Each file that you wish to be included must be explicitly specified.

    chef.add_role project_name

Adds the role, as held in the `project_name` variable, to the run_list to be used during provisioning runs. This should be used for all roles that are required for a project.

With this setup, gone are the days of repeating configuration information with every new project when they can just share, and gone are the days of directly modifying official or community maintained cookbooks just because they don't work quite how you want. 
