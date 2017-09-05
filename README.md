# Ansible role `mariadb`

[![Build Status](https://travis-ci.org/bertvv/ansible-role-mariadb.svg?branch=master)](https://travis-ci.org/bertvv/ansible-role-mariadb)


An Ansible role for managing MariaDB in RedHat-based distributions. Specifically, the responsibilities of this role are to:

- Install MariaDB packages from the official MariaDB repositories
- Remove unsafe defaults:
    - set database root password (remark that once set, this role is unable to *change* the database root password)
    - remove anonymous users
    - remove test database
- Create users and databases
- Manage configuration files `network.cnf`, and `server.cnf`

This role only supports InnoDB as storage engine.

If you like/use this role, please consider giving it a star! Thank you!

## Requirements

No specific requirements

## Role Variables

None of the variables below are required. When not defined by the user, the [default values](defaults/main.yml) are used.

### Basic configuration

| Variable                | Default     | Comments                                                                                                    |
|:------------------------|:------------|:------------------------------------------------------------------------------------------------------------|
| `mariadb_bind_address`  | '127.0.0.1' | Set this to the IP address of the network interface to listen on, or '0.0.0.0' to listen on all interfaces. |
| `mariadb_databases`     | []          | List of dicts specifyint the databases to be added. See below for details.                                  |
| `mariadb_init_scripts`  | []          | List of dicts specifying any scripts to initialise the databases. Se below for details. ta                  |
| `mariadb_port`          | 3306        | The port number used to listen to client requests                                                           |
| `mariadb_root_password` | ''          | The MariaDB root password. **It is highly recommended to change this!**                                     |
| `mariadb_swappiness`    | 0           | "Swappiness" value. System default is 60. A value of 0 means that swapping out processes is avoided.        |
| `mariadb_users`         | []          | List of dicts specifying the users to be added. See below for details.                                      |
| `mariadb_version`       | '10.2'      | The version of MariaDB to be installed. Default is the current stable release.                              |

### Server configuration

The variables below are set in `/etc/my.cnf.d/server.cnf`, specifically in the `[mariadb]` section. For more info on the values, read the [MariaDB Server System Variables documentation](https://mariadb.com/kb/en/mariadb/server-system-variables/).

| Variable                                 | Default   | Comments                                                                                  |
|:-----------------------------------------|:----------|:------------------------------------------------------------------------------------------|
| `mariadb_innodb_buffer_pool_instances`   | 8         |                                                                                           |
| `mariadb_innodb_buffer_pool_size`        | 384M      |                                                                                           |
| `mariadb_innodb_file_format`             | Barracuda |                                                                                           |
| `mariadb_innodb_file_format_check`       | 1         |                                                                                           |
| `mariadb_innodb_file_per_table`          | ON        |                                                                                           |
| `mariadb_innodb_flush_log_at_trx_commit` | 1         |                                                                                           |
| `mariadb_innodb_log_buffer_size`         | 16M       |                                                                                           |
| `mariadb_innodb_log_file_size`           | 48M       |                                                                                           |
| `mariadb_innodb_strict_mode`             | ON        |                                                                                           |
| `mariadb_join_buffer_size`               | 128K      |                                                                                           |
| `mariadb_log_warnings`                   | 1         | Log critical warnings. Set to 0 to turn off, or greater than 1 for more verbose logging.  |
| `mariadb_long_query_time`                | 10        |                                                                                           |
| `mariadb_max_allowed_packet`             | 16M       |                                                                                           |
| `mariadb_max_connections`                | 505       |                                                                                           |
| `mariadb_max_heap_table_size`            | 16M       |                                                                                           |
| `mariadb_max_user_connections`           | 500       |                                                                                           |
| `mariadb_port`                           | 3306      |                                                                                           |
| `mariadb_query_cache_size`               | 0         | The query cache is disabled by default. Set to a nonzero value to enable the query cache. |
| `mariadb_read_buffer_size`               | 128K      |                                                                                           |
| `mariadb_read_rnd_buffer_size`           | 256k      |                                                                                           |
| `mariadb_skip_name_resolve`              | 1         | Use IP addresses only. Set to 0 to resolve host names.                                    |
| `mariadb_slow_query_log`                 | 0         | Set to 1 to enable the slow query log.                                                    |
| `mariadb_sort_buffer_size`               | 2M        |                                                                                           |
| `mariadb_table_definition_cache`         | 1400      |                                                                                           |
| `mariadb_table_open_cache`               | 2000      |                                                                                           |
| `mariadb_table_open_cache_instances`     | 8         |                                                                                           |
| `mariadb_tmp_table_size`                 | 16M       |                                                                                           |

### Adding databases

Databases are defined with a dict containing the fields `name:` (required), and `init_script:` (optional). The init script is a SQL file that is executed when the database is created to initialise tables and populate it with values.

```Yaml
mariadb_databases:
  - name: appdb1
  - name: appdb2
    init_script: files/init_appdb2.sql
```

### Adding users

Users are defined with a dict containing fields `name:`, `password:`, `priv:`, and, optionally, `host:`. The password is in plain text and `priv:` specifies the privileges for this user as described in the [Ansible documentation](http://docs.ansible.com/mysql_user_module.html). An example:

```Yaml
mariadb_users:
  - name: john
    password: letmein
    priv: '*.*:ALL,GRANT'
  - name: jack
    password: sekrit
    priv: 'jacksdb.*:ALL'
    host: '192.168.56.%'
```

## Dependencies

No dependencies.

## Example Playbook

See the [test playbook](https://github.com/bertvv/ansible-role-mariadb/blob/docker-tests/test.yml)

## Testing

Test code is stored in separate branches. See the appropriate README:

- [Docker test environment](https://github.com/bertvv/ansible-role-mariadb/tree/docker-tests)
- Ansible test environment (TODO)

## License

2 clause BSD

## Contributors

Issues, feature requests, ideas, suggestions, etc. are appreciated and can be posted in the Issues section.

Pull requests are also very welcome. Please create a topic branch for your proposed changes. If you don’t, this will create conflicts in your fork when you synchronise changes after the merge. Don’t hesitate to add yourself to the contributor list below in your PR!

- [Barry Britt](https://github.com/raznikk)
- [Bert Van Vreckem](https://github.com/bertvv/) (Maintainer)
- [Louis Tournayre](https://github.com/louiznk)
- [@piuma](https://github.com/piuma)
- [Thomas Eylenbosch](https://github.com/EylenboschThomas)
