# Ansible role `mariadb`

An Ansible role for managing MariaDB in RedHat-based distributions. Specifically, the responsibilities of this role are to:

- Install MariaDB packages from the official MariaDB repositories
- Remove unsafe defaults:
    - set database root password (remark that once set, this role is unable to *change* the database root password)
    - remove anonymous users
    - remove test database
- Create users and databases
- Manage configuration files `server.cnf` and `custom.cnf`
- Upload SSL certificates and configure the server to use them

Refer to the [change log](CHANGELOG.md) for notable changes in each release.

Do you use/like this role? Please consider giving it a star. If you [rate this role](https://galaxy.ansible.com/bertvv/mariadb) on Ansible Galaxy and find it lacking in some respect, please consider opening an Issue with actionable feedback or a PR so we can improve it. Thank you!

## Requirements

No specific requirements

## Role Variables

None of the variables below are required. When not defined by the user, the [default values](defaults/main.yml) are used.

### Basic configuration

| Variable                       | Default         | Comments                                                                                                     |
| :---                           | :---            | :---                                                                                                         |
| `mariadb_bind_address`         | '127.0.0.1'     | Set this to the IP address of the network interface to listen on, or '0.0.0.0' to listen on all interfaces.  |
| `mariadb_configure_swappiness` | true            | When `true`, this role will set the "swappiness" value (see `mariadb_swappiness`.                            |
| `mariadb_custom_cnf`           | {}              | Dictionary with custom configuration.                                                                        |
| `mariadb_databases`            | []              | List of dicts specifying the databases to be added. See below for details.                                   |
| `mariadb_mirror`               | yum.mariadb.org | Download mirror for the .rpm package (1)                                                                     |
| `mariadb_port`                 | 3306            | The port number used to listen to client requests                                                            |
| `mariadb_root_password`        | ''              | The MariaDB root password. (2)                                                                               |
| `mariadb_server_cnf`           | {}              | Dictionary with server configuration.                                                                        |
| `mariadb_service`              | mariadb         | Name of the service (should e.g. be 'mysql' on CentOS for MariaDB 5.5)                                       |
| `mariadb_swappiness`           | '0'             | "Swappiness" value (string). System default is 60. A value of 0 means that swapping out processes is avoided.|
| `mariadb_users`                | []              | List of dicts specifying the users to be added. See below for details.                                       |
| `mariadb_version`              | '10.5'          | The version of MariaDB to be installed. Default is the current stable release.                               |
| `mariadb_ssl_ca_crt`           | null            | Path to the certificate authority's root certificate                  |
| `mariadb_ssl_server_crt`       | null            | Path to the server's SSL certificate                                  |
| `mariadb_ssl_server_key`       | null            | Path to the server's SSL certificate key                                 |

#### Remarks

(1) Installing MariaDB from the official repository can be very slow (some users reported more than 10 minutes). The variable `mariadb_mirror` allows you to specify a custom download mirror closer to your geographical location that may speed up the installation process. E.g.:

```yaml
# for RHEL/Fedora
mariadb_mirror: 'mariadb.mirror.nucleus.be/yum'
# for Debian
mariadb_mirror: 'mirror.mva-n.net/mariadb/repo'
```

(2) **It is highly recommended to set the database root password!** Leaving the password empty is a serious security risk. The role will issue a warning if the variable was not set.

### Server configuration

You can specify the configuration in `/etc/my.cnf.d/server.cnf` (in RHEL/Fedora, `/etc/mysql/conf.d/server.cnf` in Debian), specifically in the `[mariadb]` section, by providing a dictionary of keys/values in the variable `mariadb_server_cnf`. Please refer to the [MariaDB Server System Variables documentation](https://mariadb.com/kb/en/mariadb/server-system-variables/) for details on the possible settings.

For settings that don't get a `= value` in the config file, leave the value empty. All values should be given as strings, so numerical values should be quoted.

 In the following example, `slow-query-log`'s value is left empty:

```yaml
mariadb_server_cnf:
  slow-query-log:
  slow-query-log-file: 'mariadb-slow.log'
  long-query-time: '5.0'
```

This would result in the following `server.cnf`:

```ini
[mariadb]
slow-query-log
slow-query-log-file = mariadb-slow.log
long-query-time = 5.0
```

### Custom configuration

Settings for other sections than `[mariadb]`, can be set with `mariadb_custom_cnf`. These settings will be written to `/etc/mysql/my.cnf.d/custom.cnf` (in RHEL/Fedora, `/etc/mysql/conf.d/custom.cnf` in Debian).

Just like `mariadb_server_cnf`, the variable `mariadb_custom_cnf` should be a dictionary. Keys are section names and values are dictionaries with key-value mappings for individual settings.

The following example enables the general query log:

```yaml
mariadb_custom_cnf:
  mysqld:
    general-log:
    general-log-file: queries.log
    log-output: file
```

The resulting config file will look like this:

```ini
[mysqld]
general-log-file=queries.log
general-log
log-output=file
```

### Adding databases

Databases are defined with a dict containing the fields `name:` (required), and `init_script:` (optional). The init script is a SQL file that is executed when the database is created to initialise tables and populate it with values.

```Yaml
mariadb_databases:
  - name: appdb1
  - name: appdb2
    init_script: files/init_appdb2.sql
```

### Adding users

Users are defined with a dict containing fields `name:`, `password:`, `priv:`, and, optionally, `host:`, and `append_privs`. The password is in plain text and `priv:` specifies the privileges for this user as described in the [Ansible documentation](https://docs.ansible.com/ansible/latest/collections/community/mysql/mysql_user_module.html).

An example:

```Yaml
mariadb_users:
  - name: john
    password: letmein
    priv: '*.*:ALL,GRANT'
  - name: jack
    password: sekrit
    priv: 'jacksdb.*:ALL'
    append_privs: 'yes'
    host: '192.168.56.%'
```

## Dependencies

No dependencies.

## Example Playbook

See the [test playbook](molecule/default/converge.yml)

## Testing

This role can be tested using [Ansible Molecule](https://molecule.readthedocs.io/). The Molecule configuration will:

- Run Yamllint and Ansible Lint
- Create a Docker container named `db`
- Run a syntax check
- Apply the role with a [test playbook](molecule/default/converge.yml)
- Run acceptance tests with [BATS](https://github.com/bats-core/bats-core/)

This process is repeated for each supported Linux distribution.

### Local Docker test environment

If you want to set up a local test environment, you can use this reproducible setup based on Vagrant+VirtualBox: <https://github.com/bertvv/ansible-testenv>. Steps to install the necessary tools manually:

1. Docker and BATS should be installed on your machine (assumed to run Linux). No Docker containers should be running when you start the test.
2. As recommended by Molecule, create a python virtual environment
3. Install the software tools `python3 -m pip install molecule docker netaddr yamllint ansible-lint`
4. Navigate to the root of the role directory and run `molecule test`

Molecule automatically deletes the containers after a test. If you would like to check out the containers yourself, run `molecule converge` followed by `molecule login --host HOSTNAME`.

The Docker containers are based on images created by [Jeff Geerling](https://hub.docker.com/u/geerlingguy), specifically for Ansible testing (look for images named `geerlingguy/docker-DISTRO-ansible`). You can use any of his images, but only the distributions mentioned in [meta/main.yml](meta/main.yml) are supported.

The default config will start a Centos 7 container (the primary supported platform at this time). Choose another distro by setting the `MOLECULE_DISTRO` variable with the command, e.g.:

``` bash
MOLECULE_DISTRO=fedora32 molecule test
```

or

``` bash
MOLECULE_DISTRO=fedora32 molecule converge
```

You can run the acceptance tests on both servers with `molecule verify` or manually with

```console
SUT_IP=172.17.0.2 bats molecule/common/mariadb.bats
```

You need to initialise the variable `SUT_IP`, the system under test's IP address. The `db` container should have IP address 172.17.0.2

### Local Vagrant test environment

Alternatively, you can run the Molecule tests with full-fledged VMs instead of Docker containers. Vagrant, VirtualBox, Ansible, Molecule and BATS need to be installed on the system where you run the tests.

```console
molecule test -s vagrant
```

This will create VirtualBox VMs for the supported platforms, based on base boxes from the [Bento project](https://github.com/chef/bento/), apply the test playbook and run acceptance tests.

## License

2 clause BSD

## Contributors

- [Adail Horst](https://github.com/SpawW)
- [Barry Britt](https://github.com/raznikk)
- [Bert Van Vreckem](https://github.com/bertvv/) (Maintainer)
- [Cédric Delgehier](https://github.com/cdelgehier)
- [Dachi Natsvlishvili](https://github.com/dachinat)
- [@herd-the-cats](https://github.com/herd-the-cats)
- [Louis Tournayre](https://github.com/louiznk)
- [Nate Henderson](https://github.com/nhenderson)
- [@piuma](https://github.com/piuma)
- [@raznikk](https://github.com/raznikk)
- [Ripon Banik](https://github.com/riponbanik)
- [Thomas Eylenbosch](https://github.com/EylenboschThomas)
- [Tom Stechele](https://github.com/tomstechele)
- [Vincenzo Castiglia](https://github.com/CastixGitHub)
- [@nxet](https://github.com/nxet)
