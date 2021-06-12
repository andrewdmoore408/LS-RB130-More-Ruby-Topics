# my select implementation

def select(arr)
  selected = []

  for elem in arr
    block_result = yield(elem)
    selected << elem if block_result
  end

  selected
end

arr = [1, 2, 3, 4, 5]
strings  = ["Hello", "My name is Earl", "This array's weird, bro...", "Eh wut?"]

p select(arr) { |num| num <= 3 } == arr.select { |num| num <= 3 }
p select(arr) { |elem| elem > 3 } == arr.select { |elem| elem > 3 }

p arr.select { |elem| elem.size > 7 }

p select(strings) { |elem| elem.size > 7 }

p 100000000.size