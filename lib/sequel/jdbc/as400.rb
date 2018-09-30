# frozen-string-literal: true

require 'sequel'
require 'sequel/adapters/jdbc'

require 'jdbc/jt400'
Jdbc::JT400.load_driver

Sequel.require 'adapters/jdbc/transactions'

module Sequel
  module JDBC
    Sequel.synchronize do
      DATABASE_SETUP[:as400] = proc do |db|
        db.extend(Sequel::JDBC::AS400::DatabaseMethods)
        db.dataset_class = Sequel::JDBC::AS400::Dataset
        com.ibm.as400.access.AS400JDBCDriver
      end
    end

    # Database and Dataset support for AS400 databases accessed via JDBC.
    module AS400
      # Instance methods for AS400 Database objects accessed via JDBC.
      module DatabaseMethods
        include Sequel::JDBC::Transactions

        TRANSACTION_BEGIN = 'Transaction.begin'.freeze
        Sequel::Deprecation.deprecate_constant(self, :TRANSACTION_BEGIN)
        TRANSACTION_COMMIT = 'Transaction.commit'.freeze
        Sequel::Deprecation.deprecate_constant(self, :TRANSACTION_COMMIT)
        TRANSACTION_ROLLBACK = 'Transaction.rollback'.freeze
        Sequel::Deprecation.deprecate_constant(self, :TRANSACTION_ROLLBACK)

        # AS400 uses the :as400 database type.
        def database_type
          :as400
        end

        # TODO: Fix for AS400
        def last_insert_id(_conn, _opts = OPTS)
          nil
        end

        # AS400 supports transaction isolation levels
        def supports_transaction_isolation_levels?
          true
        end

        private

        def disconnect_error?(exception, opts)
          super || exception.message =~ /\A(The connection does not exist|Communication link failure)\./
        end

        # Use JDBC connection's setAutoCommit to false to start transactions
        def begin_transaction(conn, opts = OPTS)
          set_transaction_isolation(conn, opts)
          super
        end
      end

      # Dataset class for AS400 datasets accessed via JDBC.
      class Dataset < JDBC::Dataset
        WILDCARD = Sequel::LiteralString.new('*').freeze
        Sequel::Deprecation.deprecate_constant(self, :WILDCARD)
        FETCH_FIRST_ROW_ONLY = ' FETCH FIRST ROW ONLY'.freeze
        Sequel::Deprecation.deprecate_constant(self, :FETCH_FIRST_ROW_ONLY)
        FETCH_FIRST = ' FETCH FIRST '.freeze
        Sequel::Deprecation.deprecate_constant(self, :FETCH_FIRST)
        ROWS_ONLY = ' ROWS ONLY'.freeze
        Sequel::Deprecation.deprecate_constant(self, :ROWS_ONLY)

        # Modify the sql to limit the number of rows returned
        def select_limit_sql(sql)
          if (o = @opts[:offset])
            sql << ' OFFSET '
            literal_append(sql, o)
            sql << ' ROWS'
          end

          return unless (l = @opts[:limit])

          sql << ' FETCH FIRST '
          literal_append(sql, l)
          sql << ' ROWS ONLY'
        end

        def supports_window_functions?
          true
        end
      end
    end
  end
end
