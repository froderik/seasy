module Seasy
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
      @@defaultee = Index.new if not defined? @@defaultee
    end
  
    def add searchee, target
      save target, fragmentize( searchee )
    end

    def fragmentize searchee
       f = Fragmentizer.new
       f.fragmentize searchee
    end
  
    def save target, weights
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
        add weights[key], key, target
      end
    end
  
    def add weight, key, target
      if @store[key].nil?
        @store[key] = {target => weight}
      elsif @store[key][target].nil?
        @store[key][target] = weight
      else
        @store[key][target] += weight
      end
    end
  
    # return { target1 => weight, target2 => weight }
    def search query
      @store[query]
    end
  end

end