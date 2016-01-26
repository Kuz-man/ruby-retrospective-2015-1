class Integer
  def prime?
    return false if self == 1
    2.upto((self**0.5).floor).each { |item| return false if self % item == 0 }
    true
  end
end

class RationalSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    temp_array = []
    result_array = []
    2.upto(100).select { |sum| temp_array << produce_rats(sum) }
    temp_array = temp_array.flatten & temp_array.flatten
    result_array = temp_array.select { |item| item }.take(@limit).to_a
    result_array.each { |item| yield item }
  end

  def produce_rats(sum)
    result_array = []
    if sum.odd?
      1.upto(sum - 1).each { |i| result_array << (sum - i) / i.to_r }
    else
      1.upto(sum - 1).each { |i| result_array << i / (sum - i).to_r }
    end
    result_array
  end
end

class PrimeSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    result_array = 1.upto(Float::INFINITY).lazy.select { |item| item.prime? }.take(@limit).to_a
    result_array.each { |item| yield item }
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(limit, first: 1, second: 1)
    @limit = limit
    @first = first
    @second = second
  end

  def each
    previous, current = @first, @second
    count = 0
    while count < @limit
      yield previous
      current, previous = current + previous, current
      count += 1
    end
   end
end

module DrunkenMathematician
  module_function

  def answer
    42
  end

  def meaningless(count)
    all_rats = []
    return 1 if count == 0
    return (1 / 1).to_r if count == 1
    RationalSequence.new(count).each { |item| all_rats << item }
    array_prime = all_rats.find_all { |item| item.numerator.prime? or item.denominator.prime?}
    array_prime.reduce(:*) / (all_rats - array_prime).reduce(:*)
  end

  def aimless(count)
    return 0 if count == 0
    all_primes = []
    rats = []
    PrimeSequence.new(count).each { |item| all_primes << item }
    all_primes << 1 unless all_primes.length.even?
    all_primes.each_slice(2) { |item| rats << item[0] / item[1].to_r }
    rats.reduce(:+)
  end

  def worthless(count)
    return {} if count == 0
    return [(1 / 1.to_r)] if count == 2
    rat_cage = []
    nth_fibonacci = (FibonacciSequence.new(count).to_a - FibonacciSequence.new(count - 1).to_a)[0]
    all_rats = RationalSequence.new(count * count)
    all_rats.take_while do |rat|
      rat_cage << rat
      rat_cage.reduce(0, :+) <= nth_fibonacci
    end
  end
end