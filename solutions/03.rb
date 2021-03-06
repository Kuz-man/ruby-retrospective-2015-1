class Integer
  def prime?
    return false if self == 1
    2.upto((self**0.5).floor).each do |number|
      return false if self % number == 0
    end
    true
  end
end

class RationalSequence
  attr_reader :limit
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    numerator = 1
    counter = 0
    sum = 2
    while counter < limit
      if numerator.gcd(sum - numerator) == 1
        yield Rational(numerator, sum - numerator)
        counter += 1
      end
      if (sum.even? and numerator == sum - 1) or (sum.odd? and numerator == 1)
        sum += 1
        numerator = sum * (sum % 2)
      end
      sum.even? ? numerator += 1 : numerator += -1
    end
  end
end

class PrimeSequence
  attr_reader :limit
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    result_array = []
    result_array = 1.upto(Float::INFINITY).lazy.select do |item|
      item.prime?
    end.take(limit).to_a
    result_array.each { |item| yield item }
  end
end

class FibonacciSequence
  attr_reader :limit, :first, :second
  include Enumerable

  def initialize(limit, first: 1, second: 1)
    @limit = limit
    @first = first
    @second = second
  end

  def each
    previous, current = first, second
    count = 0
    while count < limit
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
    return 1 if count == 0
    return 1.to_r if count == 1
    all_rats = RationalSequence.new(count).to_a
    array_prime = all_rats.find_all do |item|
      item.numerator.prime? or item.denominator.prime?
    end
    array_prime.reduce(:*) / (all_rats - array_prime).reduce(:*)
  end

  def aimless(count)
    all_primes = PrimeSequence.new(count).to_a
    all_primes.each_slice(2).map do |numerator, denominator|
      Rational(numerator, denominator || 1)
    end.reduce(:+)
  end

  def worthless(count)
    rat_cage = []
    nth_fibonacci = FibonacciSequence.new(count).to_a.last
    RationalSequence.new(count * count).take_while do |rat|
      rat_cage << rat
      rat_cage.reduce(:+) <= nth_fibonacci
    end
  end
end