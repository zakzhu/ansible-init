# Ansible-Init

<!-- [![build status][shield-build]][info-build] -->

[![gitter room][shield-gitter]][info-gitter]
[![license][shield-license]][info-license]
[![release][shield-release]][info-release]
[![prs welcome][shield-prs]][info-prs]

> Project description

[TOC]

## Requirements

- **Platforms:**
  - CentOS-7
  - CentOS-8
  - Fedora
- **Dependencies:**
  - ansible
  - git

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

Use ansible-init to create a new ansible project which named "test-project":

```bash
cd ansible-init

ansible-playbook -e project=test-project -e 'author="zak zhu"' site.yml
```

## Why?

> If your project does something already catered for by another project or is particularly complex, it’s useful to provide some justification.

## Contributing

See the [contribution guide][info-contribute].

## Thanks

The following excellent people helped massively:

- [Rowan Manning](https://rowanmanning.com)

## License

Ansible-Init is licensed under the [BSD-3-Clause][info-license] license.
Copyright &copy; 2020, Zak Zhu

[info-build]: https://travis-ci.org/github/zakzhu/ansible-init
[info-contribute]: CONTRIBUTING.md
[info-gitter]: https://gitter.im/zakzhu/ansible-init
[info-license]: LICENSE
[info-release]: https://github.com/zakzhu/ansible-init/releases
[info-prs]: https://github.com/zakzhu/ansible-init/pulls
[shield-build]: https://img.shields.io/travis/zakzhu/ansible-init
[shield-gitter]: https://img.shields.io/gitter/room/zakzhu/ansible-init
[shield-license]: https://img.shields.io/github/license/zakzhu/ansible-init
[shield-release]: https://img.shields.io/github/v/release/zakzhu/ansible-init
[shield-prs]: https://img.shields.io/badge/PRs-welcome-brightgreen
