require 'sequel/jdbc/as400'

module Sequel
  module JDBC
    describe AS400 do
      it 'sets up a DATABASE_SETUP for as400' do
        expect(Sequel::JDBC::DATABASE_SETUP.key?(:as400)).to be true
      end
    end
  end
end
