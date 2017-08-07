[![Build Status](https://travis-ci.org/ecraft/sequel-jdbc-as400.svg?branch=master)](https://travis-ci.org/ecraft/sequel-jdbc-as400)

# sequel-jdbc-as400

JDBC AS400 adapter for the Sequel gem

## Development

```shell
$ bundle install
$ CONNECTION_STRING="jdbc:as400://server-name/;prompt=false;user=login;password=pw;libraries=DBNAME;query timeout mechanism=cancel; bundle exec rspec
```

(replace the connection string with a real one, pointing at a AS400 DB2 server.)
