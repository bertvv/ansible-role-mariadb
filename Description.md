## Role Variables
 Variables for improving MariaDB Performance

 | Variable                | Default     | Comments (type)                                                                                             |
 | :---                    | :---        | :---                                                                                                        |
 | `max_connect_errors`     | '100'         | The maximum number of simultaneous client connections                                           |
 | `sysdate_is_now`      | '1'        | Non-default option to make it safe for replication 1: ON / 0: OFF                        |
 +| `log_bin: /var/lib/mysql/data/mysql-bin`             | 'value: 1'  | Configure the path of all changes to the datebases                                                                 |
 +| `Expire_logs_days`       | '0'       | Number of days after which the binary log can be automatically removed
 +| `sync_binlog`      | '0'        | MariaDB will synchronize its binary log file to disk after this many events. The default is 0                                              |
 +| `query_cache_type`      | '1'      | If set to 0, the query cache is disabled (although a buffer of query_cache_size bytes is still allocated). If set to 1 all SELECT queries will be cached unless SQL_NO_CACHE is specified.                     |
 +| `thread_cache_size`       | '0'       | Number of threads server caches for re-use. Range : 0 to 16384                                             |
 +| `open_files_limit `        | 'autosized'       | The number of file descriptors available to mysqld. Increase if you are getting the Too many open files error                                  |
 +| `innodb_log_files_in_group`    | '2'       | Number of physical files in the InnoDB redo log.                                        |
 +| `innodb_buffer_pool_load_at_startup`        | '0'         | Specifies whether the buffer pool is automatically warmed up when the server starts by loading the pages held earlier. 1: ON / 0: OFF                                                      |




## Resources

- http://linuxpitstop.com/tips-to-improve-mariadb-performance/
- https://mariadb.com/kb/en/library/xtradbinnodb-server-system-variables/#innodb_flush_method
- https://www.percona.com/blog/2014/05/23/improve-innodb-performance-write-bound-loads/
- https://www.tecmint.com/mysql-mariadb-performance-tuning-and-optimization/
- https://mariadb.com/kb/en/library/configuring-mariadb-for-optimal-performance/
- https://mariadb.com/kb/en/library/optimization-and-tuning/
- https://www.saotn.org/mysql-innodb-performance-improvement/
- http://mysqlblog.fivefarmers.com/2013/08/08/understanding-max_connect_errors/
- https://dev.mysql.com/doc/refman/5.5/en/blocked-host.html
