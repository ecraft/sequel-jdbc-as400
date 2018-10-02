describe 'a limit query', needs_live_db2_server: true do
  before do
    sequel do |db|
      db.create_table!(:items) do
        primary_key :id
        String :name
      end
      class ::Item < Sequel::Model(db)
      end
    end
  end

  after do
    sequel do |db|
      db.drop_table?(:items)
      Object.send(:remove_const, :Item)
    end
  end

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
      3.times { Item.create(name: 'N') }
      some_items = Item.where(name: 'N')
      3.times { expect(some_items.first(2).size).to eq(2) }
    end
  end
end
