class Index
  def initialize
    @storage = InMemoryStorage.new
  end
  
  # set a new storage implementation instead of 
  # the naive in memory impl that is default
  #
  # the given parameter should answer to the methods 
  # save( target, weights ) and search( query )
  def storage= new_storage
    @storage = new_storage
  end
  
  def Index::default
    Index.new
  end
  
  def add searchee, target
    f = Fragmentizer.new
    weights = f.fragmentize searchee
    @storage.save target, weights
  end
  
  def search query
    @storage.search query
  end
end

# a store got search queries as keys and an array of 
# target-weight tuples as values
class InMemoryStorage
  def initialize 
    @store = {}
  end
  
  # target is a simple value - we care not what
  # weights are all fragments (indices) and their weight 
  # eg. { "aba" => 1, "ab" => 1, "ba" => 1, "b" => 1, "a" => 2 } for the string "aba"
  def save target, weights
    weights.keys.each do |key|
      if @store[key].nil?
        @store[key] = {target => weights[key]}
      elsif @store[key][target].nil?
        @store[key][target] = weights[key]
      else
        @store[key][target] += weights
      end
    end
  end
  
  # return { target1 => weight, target2 => weight }
  def search query
    @store[query]
  end
end

