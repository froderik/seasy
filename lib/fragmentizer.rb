class Fragmentizer
  def fragmentize str, weights = Hash.new( 0 )
    split = str.split
    
    if split.size > 1 
      split.each do |one|
        fragmentize one, weights
      end
      weights
    else
      length = str.length
    
      interval = 1
      while interval <= length do
        i = 0
        while i <= length - interval do
          current = str[i, interval ]
          weights[current] += 1
          i += 1
        end
        interval += 1
      end
      weights
    end
  end
end