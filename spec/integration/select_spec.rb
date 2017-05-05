describe 'a basic SELECT query', needs_live_db2_server: true do
  def sequel
    connection_string = ENV.fetch('CONNECTION_STRING') {
      raise 'You must define the CONNECTION_STRING environment variable and point it to a valid DB2 for IBM i database'
    }
    conn = Sequel.connect(connection_string)

    yield conn
  ensure
    conn && conn.disconnect
  end

  context 'when the filter excludes all the rows' do
    it 'returns an empty array' do
      sequel do |db|
        result = db[:MITMAS].where(MMCONO: 99999).to_a
        expect(result).to eq([])
      end
    end
  end

  context 'when no filter is provided, and the source table contains data' do
    it 'returns an array with the expected number of elements' do
      sequel do |db|
        result = db[:MITMAS].take(10).to_a
        expect(result.length).to eq(10)
      end
    end
  end
end
