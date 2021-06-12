def reduce(arr, initial = nil)
  skip_first = nil

  if initial.nil?
    memo = arr.first
    skip_first = true
  else
    memo = initial
  end

  for elem in arr
    if skip_first
      skip_first = false
      next
    end

    memo = yield(memo, elem)
  end

  memo
end

# test cases
array = [1, 2, 3, 4, 5]

p reduce(array) { |acc, num| acc + num } == 15                   # => 15
p reduce(array, 10) { |acc, num| acc + num } == 25               # => 25
# reduce(array) { |acc, num| acc + num if num.odd? }        # => NoMethodError: undefined method `+' for nil:NilClass

p reduce(['a', 'b', 'c']) { |acc, value| acc += value } == 'abc'     # => 'abc'
p reduce([[1, 2], ['a', 'b']]) { |acc, value| acc + value } == [1, 2, 'a', 'b']# => [1, 2, 'a', 'b']