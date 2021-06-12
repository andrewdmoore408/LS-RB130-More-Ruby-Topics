# Study the requirements below, and try to build the TodoList class.

# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.

# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(item)
    raise TypeError.new("Can only add Todo objects") unless item.class == Todo

    todos.push(item)

    todos
  end

  alias_method :<<, :add

  def each
    for todo in todos
      yield todo
    end

    self
  end

  def size
    todos.size
  end

  def first
    todos.first
  end

  def last
    todos.last
  end

  def to_a
    todos
  end

  def done?
    todos.all? { |todo| todo.done? }
  end

  def done!
    todos.each { |todo| todo.done! }
  end

  def item_at(index)
    validate(index)

    todos[index]
  end

  def mark_done_at(index)
    validate(index)

    todos[index].done!
  end

  def mark_undone_at(index)


    todos[index].undone!
  end

  def pop
    todos.pop
  end

  def remove_at(index)
    validate(index)

    todos.delete_at(index)
  end

  def select
    selected = TodoList.new(title)

    each do |item|
      selected << item if yield(item)
    end

    selected
  end

  def shift
    todos.shift
  end

  def to_s
    puts "---- #{title} ----"
    todos.each { |todo| puts todo }
  end

  private

  attr_reader :todos

  def out_of_bounds?(index)
    index >= todos.size || index < -todos.size
  end

  def validate(index)
    raise IndexError.new("Index is out of bounds") if out_of_bounds?(index)
  end
end

# The assignment for you is to figure out the rest of the implementation in order for the below code to work. Note that this assignment doesn't have anything to do with blocks yet -- it's just basic Ruby at this point.

# Implement the rest of the TodoList so that we can write this code:

# given
todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")
list = TodoList.new("Today's Todos")

list.add(todo1)
list.add(todo2)
list.add(todo3)

todo1.done!

results = list.select { |todo| todo.done? }    # you need to implement this method

puts results