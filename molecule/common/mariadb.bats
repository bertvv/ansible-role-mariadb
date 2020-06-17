#! /usr/bin/env bats
#
# Functional tests for a MariaDB server set up wit Ansible role bertvv.mariadb
#
# The variable SUT_IP, the IP address of the System Under Test must be set
# outside of the script.

#---------- Variables ---------------------------------------------------------

mariadb_root_password='atOrryag&'
user1='app1usr'
user2='app2usr'
db1='app1db'
db2='app2db'
pw1='Ej{Quiv3'
pw2='tytsHeab=3'
table='TestTable'

#---------- Helper functions --------------------------------------------------

# Usage: show_tables USER PASSWORD DB
#
# Have USER run the SQL query "SHOW TABLES" on the specified database.
show_tables() {
  local user="${1}"
  local password="${2}"
  local database="${3}"

  mysql --host="${SUT_IP}" \
    --user="${user}" \
    --password="${password}" \
    --execute="SHOW TABLES;" \
    "${database}"
}

# Usage: select USER PASSWORD DB TABLE
#
# Have USER run the SQL query "SELECT * FROM" on the specified database and
# table.
query_select() {
  local user="${1}"
  local password="${2}"
  local database="${3}"
  local table="${4}"

  mysql --host="${SUT_IP}" \
    --user="${user}" \
    --password="${password}" \
    --execute="SELECT * FROM ${table}" \
    "${database}"
}

# Usage: query USER PW DB QUERY
#
# Have USER run QUERY on the specified database.
query() {
  local user="${1}"
  local password="${2}"
  local database="${3}"
  local query="${4}"

  mysql --host="${SUT_IP}" \
    --user="${user}" \
    --password="${password}" \
    --execute="${query}" \
    "${database}"
}

#---------- Tests -------------------------------------------------------------

@test 'Root user should not be able to run a query remotely' {
  run show_tables mysql root "${mariadb_root_password}"

  [ "${status}" -ne "0" ]
  echo "${output}"
  grep 'Access denied for user' <<< "${output}"
}

@test 'User should be able to run SHOW TABLES on own database' {
  show_tables "${user1}" "${pw1}" "${db1}"
  show_tables "${user2}" "${pw2}" "${db2}"
}

@test 'User should not be able to run SHOW TABLES on other database' {
  run show_tables "${user2}" "${pw1}" "${db2}"
  [ "${status}" -ne "0" ]
  echo "${output}"
  grep 'Access denied for user' <<< "${output}"

  run show_tables "${user1}" "${pw2}" "${db1}"
  [ "${status}" -ne "0" ]
  echo "${output}"
  grep 'Access denied for user' <<< "${output}"
}

@test 'User should be able to run SELECT * FROM TABLE on own database' {
  query_select "${user1}" "${pw1}" "${db1}" "${table}"
  query_select "${user2}" "${pw2}" "${db2}" "${table}"
}

@test 'User should not be able to run SELECT * FROM TABLE on other database' {
  run show_tables "${user2}" "${pw1}" "${db2}"
  [ "${status}" -ne "0" ]
  echo "${output}"
  grep 'Access denied for user' <<< "${output}"

  run show_tables "${user1}" "${pw2}" "${db1}"
  [ "${status}" -ne "0" ]
  echo "${output}"
  grep 'Access denied for user' <<< "${output}"
}

@test 'User should be able to run UPDATE query on own database' {
  local test_query="UPDATE TestTable SET SurName='Smith' WHERE Id=1;"

  query "${user1}" "${pw1}" "${db1}" "${test_query}"
  query "${user2}" "${pw2}" "${db2}" "${test_query}"
}

@test 'User should not be able to run UPDATE query on other database' {
  local test_query="UPDATE TestTable SET SurName='Smith' WHERE Id=1;"
  run query "${user2}" "${pw1}" "${db1}" "${test_query}"
  [ "${status}" -ne "0" ]
  echo "${output}"
  grep 'Access denied for user' <<< "${output}"

  run query "${user1}" "${pw2}" "${db2}" "${test_query}"
  [ "${status}" -ne "0" ]
  echo "${output}"
  grep 'Access denied for user' <<< "${output}"
}

