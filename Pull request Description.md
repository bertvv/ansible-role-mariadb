#Pull request information - Ansible role `mariadb`

## Role Variables
Variables for improving MariaDB Performance

| Variable                         | Default     | Comments (type)                                                                                             |
| :---                             | :---        | :---                                                                                                        |
| `mariadb_file_per_table`         | '1'         | 1: enable InnoDB file-per-table, 0:disable InnoDB file-per-table                                            |
| `mariadb_buffer_pool_size`       | '1G'        | Configure the InnoDB Buffer pool Size, Default is 1 GB                                                      |
| `mariadb_sysctl_p:`              | 'value: 1'  | Configure a systctl_p name, value and state                                                                 |
| `mariadb_Max_connections`        | '300'       | Configure how many concurrent connections can be initiated on your MariaDB server                           |
| `mariadb_thread_cache_size`      | '16'        | Configure Thread cache size                                                                                 |
| `mariadb_skip_name_resolve`      | 'true'      | True: Disable DNS lookips, false: enable DNS lookups                                                        |
| `query_cache_size`       		   | '64M'       | Configure query chachesize                                                                                  |
| `mariadb_tmp_table_size `        | '64M'       | Configure tmp table size                                                                                    |
| `max_heap_table_size`            | '64M'       | Configure max heap max_heap_tablesize                                                                       |
| `mariadb_slow_query_log`         | '1'         | 1: Enable slow query log, 0:disalbe slow query log                                                          |
| `mariadb_long_query_time`        | '1'         | Configure long query time                                                                                   |
| `mariadb_wait_timeout`          | '60'        | Configure idle connections                                                                                  |


## Resources

  - http://linuxpitstop.com/tips-to-improve-mariadb-performance/
  - http://docs.ansible.com/ansible/sysctl_module.html
  - http://docs.ansible.com/ansible/playbooks_conditionals.html
  - http://stackoverflow.com/questions/8020297/mysql-my-cnf-file-found-option-without-preceding-group#comment9816346_8020319
  - http://stackoverflow.com/questions/22651656/any-way-to-check-if-innodb-file-per-table-is-set-in-mysql-5-5-per-table
  - http://stackoverflow.com/questions/19589186/innodb-buffer-pool-size-variable-and-buffer-pool-size-in-innodb-status-mismatch
  - http://askubuntu.com/questions/103915/how-do-i-configure-swappiness

