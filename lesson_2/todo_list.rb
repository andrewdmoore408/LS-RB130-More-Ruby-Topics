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

  def all_done
    select { |item| item.done? }
  end

  def all_not_done
    select { |item| !(item.done?) }
  end

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

  def find_by_title(title)
    each do |item|
      return item if item.title == title
    end

    nil
  end

  def item_at(index)
    check_for_valid(index)

    todos[index]
  end

  def mark_all_done
    each { |item| item.done! }
  end

  def mark_all_undone
    each { |item| item.undone! }
  end

  def mark_done(item_title)
    each do |item|
      if item.title == item_title
        item.done!
      end
    end
  end

  def mark_done_at(index)
    check_for_valid(index)

    todos[index].done!
  end

  def mark_undone_at(index)
    check_for_valid(index)

    todos[index].undone!
  end

  def pop
    todos.pop
  end

  def remove_at(index)
    check_for_valid(index)

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

  def check_for_valid(index)
    raise IndexError.new("Index is out of bounds") if out_of_bounds?(index)
  end
end