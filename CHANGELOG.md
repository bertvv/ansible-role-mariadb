# Change log

This file contains al notable changes to the mariadb Ansible role.

This file adheres to the guidelines of [http://keepachangelog.com/](http://keepachangelog.com/). Versioning follows [Semantic Versioning](http://semver.org/).

## 1.1.1 - 2015-04-28

### Changed

- Fixed a bug that makes the role fail when `mariadb_init_scripts` is undefined.

## 1.1.0 - 2015-04-26

### Added

- Databases can be initialised with a SQL script

## 1.0.0 - 2015-04-25

First release!

### Added

- Install MariaDB
- Secure installation (change root password, delete anonymous user, test table)
- Manage bind_port
- Create databases and users

