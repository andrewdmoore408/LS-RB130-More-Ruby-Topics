require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'todo_list'

class TodoListTest < MiniTest::Test

  attr_reader :todo1, :todo2, :todo3, :todos, :list

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    list.add(todo1)
    list.add(todo2)
    list.add(todo3)
  end

  def test_to_a
    assert_equal(todos, list.to_a)
  end

  def test_size
    assert_equal(3, list.size)
  end

  def test_first
    assert_equal(todo1, list.first)
  end

  def test_last
    assert_equal(todo3, list.last)
  end

  def test_shift
    shifted = list.shift
    assert_equal([todo2, todo3], list.to_a)
    assert_equal(todo1, shifted)
  end

  def test_pop
    popped = list.pop
    assert_equal([todo1, todo2], list.to_a)
    assert_equal(todo3, popped)
  end

  def test_done?
    refute(list.done?, "#done? did not return false")
  end

  def test_typeerror_adding_non_todo
    assert_raises(TypeError) { list << "Vacuum rug" }
    assert_raises(TypeError) { list << 5 }
    assert_raises(TypeError) { list << { "Todo" => "Wash dishes" } }
    assert_raises(TypeError) { list << :to_s }
  end

  def test_shovel
    list_oid = list.object_id
    new_todo = Todo.new("Finish test suite")
    list << new_todo
    todos << new_todo

    assert_equal(list_oid, list.object_id)
    assert_equal(4, list.size)
    assert_equal(new_todo, list.last)
    assert_equal(todos, list.to_a)
  end

  def test_add
    list_oid = list.object_id
    new_todo = Todo.new("Finish test suite")
    list.add(new_todo)
    todos << new_todo

    assert_equal(list_oid, list.object_id)
    assert_equal(4, list.size)
    assert_equal(new_todo, list.last)
    assert_equal(todos, list.to_a)
  end

  def test_item_at
    assert_equal(todos[2], list.item_at(2))
    assert_equal(todos[0], list.item_at(-3))
    assert_raises(IndexError) { list.item_at(3) }
    assert_raises(IndexError) { list.item_at(-4) }
  end

  def test_mark_done_at
    assert_raises(IndexError) { list.mark_done_at(100)}
    list.mark_done_at(1)
    assert_equal(true, todo2.done?)
    assert_equal(false, todo1.done?)
    assert_equal(false, todo3.done?)
  end

  def test_mark_undone_at
    assert_raises(IndexError) { list.mark_undone_at(100)}

    todos.each { |todo| todo.done! }
    list.mark_undone_at(1)

    assert_equal(false, todo2.done?)
    assert_equal(true, todo1.done?)
    assert_equal(true, todo3.done?)
  end

  def test_done!
    list.done!
    assert_equal(true, todo2.done?)
    assert_equal(true, todo1.done?)
    assert_equal(true, todo3.done?)
    assert_equal(true, list.done?)
  end

  def test_remove_at
    assert_raises(IndexError) { list.mark_undone_at(-4) }
    removed = list.remove_at(2)

    assert_equal(todo3, removed)
    assert_equal([todo1, todo2], list.to_a)
  end

  def test_to_s
    output = <<~OUTPUT.chomp
             ---- Today's Todos ----
             [ ] Buy milk
             [ ] Clean room
             [ ] Go to gym
             OUTPUT

    assert_equal(output, list.to_s)
  end

  def test_to_s_item_done
    todo2.done!

    output = <<~OUTPUT.chomp
             ---- Today's Todos ----
             [ ] Buy milk
             [X] Clean room
             [ ] Go to gym
             OUTPUT

    assert_equal(output, list.to_s)
  end

  def test_to_s_all_items_done
    list.done!

    output = <<~OUTPUT.chomp
             ---- Today's Todos ----
             [X] Buy milk
             [X] Clean room
             [X] Go to gym
             OUTPUT

    assert_equal(output, list.to_s)
  end

  def test_each_iterates
    array = []

    list.each { |todo| array << todo }

    assert_equal(array, list.to_a)
  end

  def test_each_returns_original
    each_returned = list.each { |item| nil }
    assert_same(each_returned, list)
  end

  def test_select
    # assert_equal(TodoList.new("Today's Todos"), list.select { |item| nil })
    refute_same(TodoList.new("Today's Todos"), list.select { |item| nil })
  end
end