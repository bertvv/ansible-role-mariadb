# Ansible role `mariadb`

An Ansible role for managing MariaDB in RedHat-based distributions. Specifically, the responsibilities of this role are to:

- Install MariaDB packages
- Remove unsafe defaults:
    - set database root password (remark that once set, this role is unable to *change* the database root password)
    - remove anonymous users
    - remove test database
- Create users and databases
- Configure network interface(s) to listen on

## Requirements

No specific requirements

## Role Variables

None of the variables below are required. When not defined by the user, the default values are used.

| Variable                | Default     | Comments (type)                                                                                             |
| :---                    | :---        | :---                                                                                                        |
| `mariadb_databases`     | []          | List of names of the databases to be added                                                                  |
| `mariadb_users`         | []          | List of dicts specifying the users to be added. See below for details.                                      |
| `mariadb_root_password` | ''          | The MariaDB root password. **It is highly recommended to change this!**                                     |
| `mariadb_bind_address`  | '127.0.0.1' | Set this to the IP address of the network interface to listen on, or '0.0.0.0' to listen on all interfaces. |
| `mariadb_init_scripts`  | []          | List of dicts specifying any scripts to initialise the databases. Se below for details. ta                  |

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

### Initialising databases

Init scripts are specified with a dict containing the fields `script:` and `database:`. The former specifies the location of the SQL script, the latter the name of the database to apply the script to. An example:

```Yaml
mariadb_init_scripts:
  - database: myappdb
    script: files/init.sql
```

This will execute the SQL script `files/init.sql` (relative to the Ansible main directory) in the database `myappdb`.

## Dependencies

No dependencies.

## Example Playbook

See the [test playbook](https://github.com/bertvv/ansible-role-mariadb/blob/docker-tests/test.yml)

## Testing

Test code is stored in separate branches. See the appropriate README

- [Docker test environment](https://github.com/bertvv/ansible-role-mariadb/tree/docker-tests)
- Ansible test environment (TODO)

## License

2 clause BSD

## Contributors

Issues, feature requests, ideas, suggestions, etc. are appreciated and can be posted in the Issues section.

Pull requests are also very welcome. Please create a topic branch for your proposed changes. If you don’t, this will create conflicts in your fork after the merge. Don’t hesitate to add yourself to the contributor list below in your PR!

- [Bert Van Vreckem](https://github.com/bertvv/) (Maintainer)
