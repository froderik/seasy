require 'singleton'

module Seasy

  class Configuration 
    include Singleton
    
    attr_accessor :storage
    
    def initialize
      @storage = Seasy::InMemoryStorage
    end
  end
  
  def configure
    config = Seasy::Configuration.instance
    yield config
  end
  
  class Index
    attr_accessor :name
    
    def initialize name = 'default'
      @name = name
      @storage = Configuration.instance.storage.new
    end

    def Index::default
      @@defaultee = Index.new if not defined? @@defaultee
    end
    
    def Index::with_name name
      stringed_name = name.to_s
      @@indices = {} if not defined? @@indices
      if @@indices[stringed_name].nil?
        @@indices[stringed_name] = Index.new stringed_name
      end
      @@indices[stringed_name]
    end
  
    def add searchee, target, options = {}
      save target, fragmentize( searchee ), options
    end

    def search query
      @storage.search query
    end
    
    def clear 
      @storage.clear
    end
    
    private
    
    def fragmentize searchee
       f = Fragmentizer.new
       f.fragmentize searchee
    end
  
    def save target, weights, options
      @storage.save target, weights, options
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
    def save target, weights, options = {}
      real_target = target
      real_target = options[:source] unless options[:source].nil?
      weights.keys.each do |key|
        add weights[key], key, real_target
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
      @store[query] || {}
    end
    
    def clear
      @store = {}
    end
    
  end

  module_function :configure
end