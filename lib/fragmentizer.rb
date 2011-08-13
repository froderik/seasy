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
      
      # loop over all possible intervals
      (1..length).each do |interval|
        fragmentize_in_interval str, interval, weights
        #interval += 1
      end
      weights
    end
  end
  
  def fragmentize_in_interval str, interval, weights
    length = str.length
    (0..length-interval).each do |i|
      current = str[i, interval ]
      weights[current] += 1
    end
  end
end