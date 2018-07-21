# Chef Evaluation
## Purpose: Stand up an Automate v2.0 evaluation environment 
## yacs - Yet Another Chef Server ~cookbook~ _setup_: we enjoy shaving
- Chef Automate v2.0
- Chef Server (Manage-less)
- X Nodes to Bootstrap and manage

`chef-infra` is a bash script that will create or download all the resources needed to
setup an evaluation of the Chef Infrastructure.

### Prereqs:
- [Vitualbox](https://www.virtualbox.org/wiki/Downloads) (tested v5.2.12)
- [vagrant](https://www.vagrantup.com/downloads.html) (tested v2.1.1)
- [chefdk](https://downloads.chef.io/chefdk/3.0.36) (tested v2.5.3)
- tested on MacBook Pro w/ 7GB free physical mem where a2+chef+2 nodes used 4GB memory & 1GB on disk

_!Warning! This is running a number of machines on a local environment.  As such,
it is a resource hog. Attention to available resources is advised._

## Quick Start:
- Clone this repo and `cd chef-evaluation`
- Create ./automate.license with a valid Automate license. Otherwise, add it when logging in for the first time
- From the base directory run `chef-infra setup`
- Instructions for logging in are printed to the terminal when setup is complete
- Look at `chef-infra -h` for more info & teardown instructions

### Troubleshooting:
Ideally, `chef-infra setup` will "just work" and give you everything required.  However, this isn't a perfect world.  If things don't work here are a few things to try.
1. View automate logs `chef-infra log`
1. Did a2 converge w/out error? Does ./a2-token exist? If no, try `vagrant provision a2`
1. Did srvr converge w/out error? Does ./.chef/admin.pem exist? If no, try `vagrant provision srvr`
1. Did nodeX converge w/out error? If no, check status of a2 and srvr.  Try `knife ssl fetch && knife cookbook upload audit && knife role from file base.rb`.  Was the DevSec profile added to Automate? If no, log in and do that.

### Manage nodes
- Create/install a single node only:
  - `chef-infra -o`: only create configuration files
  - `vagrant up [a2|srvr|node1[n]]`: only bring up element(s) desired
- Retry configuration of a single node: `vagrant provision [a2|srvr|node1[n]]`

---
## Chef Workstation:
Once initial setup is complete and/or the Vagrantfile is created, Chef Workstation can be
setup with the following command
- `chef-infra setup -w`

---
## Habitat on-prem Builder:
Once initial setup is complete and/or the Vagrantfile is created, Habitat Builder can be
setup with the following command
- `chef-infra setup -b`


---
## CI Server:
Once initial setup is complete and the Chef Infrastructure is working, node10 can be turned into a Jenkins server by running the following command
- `pipeline`

---
## Extra Credit:
The Chef nodes are inspected via the DevSec Linux Baseline Compliance profile by default. There will be several failed controls by default. There is a cookbook in the ./cookbooks directory called `devsec_hardening` which has a default recipe with the necessary resources to resolve the `entroyp` control failure seen in the Compliance tab details for each node. So, for practice:
  1. Use test kitchen to spin a development image and test the `entropy` control that has been copied into the tests for that cookbook
  2. Uncomment the resources in the `default.rb` recipe, which will fix the entropy failure
  3. Converge and test the cookbook to see that the `entropy` control now passes

---
## Extra Extra Credit:
Now that there is a cookbook that will start resolving the control failures, upload it and watch the number of failed controls decrease!
  1. Upload the cookbook to the Chef server (hint: be in the root of the repo)
      - `knife cookbook upload devsec_hardening`
  2. Modify the `./roles/base.rb` file to include the new recipe
  3. Upload the new role (hint: be in the root of the repo)
      - `knife role from file roles/base.rb`
The nodes in this demo run `chef-client` every 5 minutes, and should run the new cookbook on thier next run, and also report to Compliance that the `entropy` control is passed.

---
### Patterns:
- Bootstrap during provisioning: scripts/setup_node.sh
- Backup: see `chef-infra do_backup()`

### Development:
- TODO evaluate hab chef-server & chef-client
- TODO add windows node
- TODO move installs into separate scripts add a helper command to print them out

### Contributions Welcome and encouraged.  Ways to contribute:
- Open an issue: https://github.com/mtyler/chef-evaluation/issues
- Submit a PR: clone the repo, create a branch, make the change, submit
