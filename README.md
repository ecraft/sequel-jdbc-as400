[![Build Status](https://travis-ci.org/ecraft/sequel-jdbc-as400.svg?branch=master)](https://travis-ci.org/ecraft/sequel-jdbc-as400)

# sequel-jdbc-as400

JDBC AS400 adapter for the [Sequel](https://github.com/jeremyevans/sequel) Ruby gem

This gem is a fork of the code which used to be a part of the Sequel codebase, but which was removed as of Sequel 5. (unreleased at the time of writing) If your application relies on the as400 adapter, use this gem together with `sequel` to still be able to connect to AS400 databases.

## Development

```shell
$ bundle install
$ CONNECTION_STRING="jdbc:as400://server-name/;prompt=false;user=login;password=pw;libraries=DBNAME;query timeout mechanism=cancel; bundle exec rspec
```

(replace the connection string with a real one, pointing at a AS400 DB2 server.)

## Releasing a new gem version

Bump version in version.rb manually, then run the following:

```shell
$ bundle exec git release v1.0.0
$ bundle exec rake release
```
