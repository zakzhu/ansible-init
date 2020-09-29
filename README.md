# Ansible-Init

<!-- [![build status][shield-build]][info-build] -->

[![gitter room][shield-gitter]][info-gitter]
[![license][shield-license]][info-license]
[![release][shield-release]][info-release]
[![prs welcome][shield-prs]][info-prs]

Ansible-Init is designed to initialize a new project of ansible playbook for best practice.  

[TOC]

## Requirements

- **Platforms:**
  - CentOS-7
  - CentOS-8
  - Fedora
- **Dependencies:**
  - ansible\>=2.9, <2.10, !=2.9.10
  - git>=1.8.3.1

## Installation

- Install dependencies:

  ```bash
  yum -y install ansible
  ```

  ```bash
  yum -y install git
  ```

- Install ansible-init:

  ```bash
  git clone https://github.com/zakzhu/ansible-init.git
  ```

## Usage

```bash
cd ansible-init

ansible-playbook -e project=<project-name> -e 'author="<full name>"' site.yml
```

## Examples

To generate a new project of ansible playbook with ansible-init, simply run:

```bash
cd ansible-init

ansible-playbook -e project=my-new-project -e 'author="zak zhu"' site.yml
```

## Why?

After have learned ansible documentation about best practices, I want to find a CLI tool that could simply generate a new project of ansible playbook, but nothing have found. So I use ansible to write the ansible-init tool which can initialize a new project of ansible playbook for best practice.

To achieve best practice, the design concept  of ansible-init mostly follows two thought below:  

- **Decouple and Share**
- **Convention over Configuration**

### Directory Layout

The top level of a new ansible project's directory would contain files and directories like so:

```
├── ansible.cfg
├── CONTRIBUTING.md
├── docs
├── inventories
│   ├── production
│   │   ├── group_vars
│   │   ├── host_vars
│   │   └── inventory
│   └── staging
│       ├── group_vars
│       ├── host_vars
│       └── inventory
├── LICENSE
├── plugins
│   └── README.md
├── README.md
├── roles
│   ├── common
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   ├── handlers
│   │   │   ├── from_common.yml
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   ├── common.yml
│   │   │   └── main.yml
│   │   ├── templates
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── post_roles
│   │   └── common
│   │       ├── defaults
│   │       │   └── main.yml
│   │       ├── handlers
│   │       │   ├── from_common.yml
│   │       │   ├── from_set_local_facts.yml
│   │       │   └── main.yml
│   │       ├── meta
│   │       │   └── main.yml
│   │       ├── README.md
│   │       ├── tasks
│   │       │   ├── common.yml
│   │       │   ├── main.yml
│   │       │   └── set_local_facts.yml
│   │       ├── tests
│   │       │   ├── inventory
│   │       │   └── test.yml
│   │       └── vars
│   │           └── main.yml
│   └── pre_roles
│       └── common
│           ├── defaults
│           │   └── main.yml
│           ├── handlers
│           │   ├── from_common.yml
│           │   └── main.yml
│           ├── meta
│           │   └── main.yml
│           ├── README.md
│           ├── tasks
│           │   ├── common.yml
│           │   └── main.yml
│           ├── tests
│           │   ├── inventory
│           │   └── test.yml
│           └── vars
│               └── main.yml
├── site.yml
├── tests
├── tmp
├── TODO.md
└── utils
```

### Main Playbook

The file named site.yml is main playbook of a new project as follows:

```yaml
---
- name: "{{ playbook_dir | basename }}"
  hosts: localhost
  remote_user:
  gather_facts: yes
  vars:
    status: "{{ ansible_local[stats_file_name]['status'] | default('0') }}"
  force_handlers: no
  pre_tasks:
    - name: only collect the default minimum amount of facts
      setup:
        gather_subset:
          - "!all"

    - when: status == '0'
      block:
        - import_role:
            name: pre_roles/common
          tags:
            - pr_r_common
        - meta: flush_handlers

  tasks:
    - when: status == '0'
      block:
        - import_role:
            name: common
          tags:
            - r_common
        - meta: flush_handlers

  post_tasks:
    - when: status == '0'
      block:
        - import_role:
            name: post_roles/common
          tags:
            - po_r_common
        - meta: flush_handlers

```

### Some Conventions

For best practice, I specify some conventions in a new project of ansible playbook. And I recommend you follow these conventions.

#### Play name

> **NOTE:**
>
> There is a convention what I specify. 
>
> The play name is a fixed writing.

```yaml
- name: "{{ playbook_dir | basename }}"
```

#### Group by roles

```
├── roles
│   ├── common
│   │
│   ├── bar_role
│   │
│   ├── foo_role
│   │
│   ├── post_roles
│   │   ├── common
│   │   │
│   │   ├── post_bar_role
│   │   │
│   │   └── post_foo_role
│   │
│   ├── pre_roles
│   │   ├── common
│   │   │
│   │   ├── pre_bar_role
│   │   │
│   │   └── pre_foo_role
```

#### Handlers file

- handlers file name

  ```
  from_<tasks file name>.yml    # e.g. from_common.yml
  ```

- decouple handlers file

  For example:

  `cat roles/common/handlers/main.yml`

  > ```yaml
  > ---
  > # handlers file for common
  > 
  > # Below is a code example
  > - import_tasks: from_common.yml
  > ```

  `cat roles/common/handlers/from_common.yml `

  > ```yaml
  > ---
  > # Below is a code example
  > - name: "({{ role_name }}) hello world"
  >   debug:
  > ```

- always name handlers

  Handler name format:

  > **NOTE:**
  >
  > There is a convention what I specify. 
  >
  > `({{ role_name }})` is a fixed writing in the head of handler name.

  ```yaml
  - name: "({{ role_name }}) HANDLER NAME"
  ```

  For example:

  ```yaml
  - name: "({{ role_name }}) hello world"
  ```

#### Tasks file

- decouple tasks file

  For example:

  `cat roles/common/tasks/main.yml`

  > ```yaml
  > ---
  > # tasks file for common
  > 
  > - import_tasks: common.yml
  >   tags:
  >     - r_common_t_common
  > ```

  `cat roles/common/tasks/common.yml`

  > ```yaml
  > ---
  > # Below is a code example
  > - name: <r_common_t_common> test task
  >   debug:
  > 
  > - name: <r_common_t_common> test trigger handler
  >   command: echo
  >   notify: "({{ role_name }}) hello world"
  > ```

- always name tasks

  Task name format:

  > **NOTE:** 
  >
  > There is a convention what I specify. 
  >
  > The task name should start with a tag name enclosed in angle brackets (e.g. `-name: <r_common_t_common> test task`).
  >
  > And the tag name in the task name should follow the tag that you apply in the tasks/main.yml file. 

  ```yaml
  - name: <tag name> TASK NAME
  ```

#### Tags name

For example:

```yaml
# ansible-playbook --list-tasks site.yml 

playbook: site.yml

  play #1 (localhost): my-new-project	TAGS: []
    tasks:
      only collect the default minimum amount of facts	TAGS: []
      pre_roles/common : <pr_r_common_t_common> be failed when the os not supported	TAGS: [pr_r_common, pr_r_common_t_common]
      pre_roles/common : <pr_r_common_t_common> set start stats	TAGS: [pr_r_common, pr_r_common_t_common]
      common : <r_common_t_common> test task	TAGS: [r_common, r_common_t_common]
      common : <r_common_t_common> test trigger handler	TAGS: [r_common, r_common_t_common]
      post_roles/common : <po_r_common_t_common> set end stats	TAGS: [po_r_common, po_r_common_t_common]
      post_roles/common : <po_r_common_t_set_local_facts> create /etc/ansible/facts.d/ dir	TAGS: [po_r_common, po_r_common_t_set_local_facts]
      post_roles/common : <po_r_common_t_set_local_facts> copy custom stats to local facts	TAGS: [po_r_common, po_r_common_t_set_local_facts]
```

- role tag

  > **NOTE:**
  >
  > There is a convention what I specify. 
  >
  > One role applies one tag at least.

  ```
  pr_r_common     # complete spelling: "pre_roles roles common"
                  # tag meaning: roles/pre_roles/common role
  
  r_common        # complete spelling: "roles common"
                  # tag meaning: roles/common role
  				
  po_r_common     # complete spelling: "post_roles roles common"
                  # tag meaning: roles/post_roles/common role
  ```

- tasks tag

  > **NOTE:**
  >
  > There is a convention what I specify. 
  >
  > One tasks file applies one tag at least.

  ```
  pr_r_common_t_common            # complete spelling: "pre_roles roles common tasks common"
                                  # tag meaning: roles/pre_roles/common/tasks/common.yml tasks file
  						
  r_common_t_common               # complete spelling: "roles common tasks common"
                                  # tag meaning: roles/common/tasks/common.yml tasks file	
                          
  po_r_common_t_common            # complete spelling: "post_roles roles common tasks common"
                                  # tag meaning: roles/post_roles/common/tasks/common.yml tasks file
  
  po_r_common_t_set_local_facts   # complete spelling: "post_roles roles common tasks set_local_facts"
                                  # tag meaning: roles/post_roles/common/tasks/set_local_facts.yml tasks file
  ```

## Contributing

See the [contribution guide][info-contribute].

## Frequently asked questions

Please see [FAQ.md][info-faq] for frequently asked questions.

## Thanks

The following excellent people helped massively:

- [Rowan Manning](https://rowanmanning.com)

## License

Ansible-Init is licensed under the [BSD-3-Clause][info-license] license.
Copyright &copy; 2020, Zak Zhu

[info-build]: https://travis-ci.org/github/zakzhu/ansible-init
[info-contribute]: CONTRIBUTING.md
[info-faq]: FAQ.md
[info-gitter]: https://gitter.im/zakzhu/ansible-init
[info-license]: LICENSE
[info-release]: https://github.com/zakzhu/ansible-init/releases
[info-prs]: https://github.com/zakzhu/ansible-init/pulls
[shield-build]: https://img.shields.io/travis/zakzhu/ansible-init
[shield-gitter]: https://img.shields.io/gitter/room/zakzhu/ansible-init
[shield-license]: https://img.shields.io/github/license/zakzhu/ansible-init
[shield-release]: https://img.shields.io/github/v/release/zakzhu/ansible-init
[shield-prs]: https://img.shields.io/badge/PRs-welcome-brightgreen
