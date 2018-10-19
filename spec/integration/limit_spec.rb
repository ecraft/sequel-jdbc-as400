describe 'a limit query', needs_live_db2_server: true do
  def sequel
    connection_string = ENV.fetch('CONNECTION_STRING') {
      raise 'You must define the CONNECTION_STRING environment variable and point it to a valid DB2 for IBM i database'
    }
    conn = Sequel.connect(connection_string)

    yield conn
  ensure
    conn && conn.disconnect
  end

  context 'when using a cached dataset' do
    it 'should return an array with the correct number of elements' do
      # Sequel starts caching dataset query placeholder arguments on 3rd use
      sequel do |db|
        3.times { expect(db[:MITMAS].first(5).size).to eq(5) }
      end
    end
  end
end
