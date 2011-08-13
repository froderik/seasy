class Index
  def initialize
    @storage = InMemoryStorage.new
  end
  
  def storage= new_storage
    @storage = new_storage
  end
  
  def Index::default
    Index.new
  end
  
  def add searchee, target
    f = Fragmentizer.new
    weights = f.fragmentize searchee
    @storage.save weights, target
  end
  
  def search query
  end
end

# a store got search queries as keys and an array of 
# target-weight tuples as values
class InMemoryStorage
  def initialize 
    @store = {}
  end
  
  def save weights, target
    weights.keys.each do |key|
      @store[key] = [[target,weights[key]]]
    end
  end
  
  def search query
    @store[query].first.first
  end
end

