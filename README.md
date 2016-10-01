# Ansible role `mariadb`

An Ansible role for managing MariaDB in RedHat-based distributions. Specifically, the responsibilities of this role are to:

- Install MariaDB packages
- Remove unsafe defaults:
    - change root password
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

See the [test playbook](tests/test.yml)

## Testing

The `tests` directory contains tests for this role in the form of a Vagrant environment. When running `vagrant up`, a VM is generated for each supported platform and the test playbook is applied to it.

The directory `tests/roles/mariadb` is a symbolic link that should point to the root of this project in order to work. To create it, do

```ShellSession
$ cd tests/
$ mkdir roles
$ ln -frs ../../PROJECT_DIR roles/mariadb
```

You may want to change the base box into one that you like. The current one is based on Box-Cutter's [CentOS Packer template](https://github.com/boxcutter/centos).

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section. Pull requests are also very welcome. Preferably, create a topic branch and when submitting, squash your commits into one (with a descriptive message).

## License

BSD

## Author Information

Bert Van Vreckem (bert.vanvreckem@gmail.com)

