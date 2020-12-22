defmodule TodoTest do
  use ExUnit.Case
  #doctest Todo

  test "todo_entry_map" do
    list =
      Todo.List.new()
      |> Todo.List.add_entry(%{date: ~D[2018-01-01], title: "Dinner"})
      |> Todo.List.add_entry(%{date: ~D[2018-01-02], title: "Dentist"})
      |> Todo.List.add_entry(%{date: ~D[2018-01-02], title: "Meeting"})

    assert [%{date: ~D[2018-01-01], title: "Dinner", id: 1}] == Todo.List.entries(list, ~D[2018-01-01])
    assert [] == Todo.List.entries(list, ~D[2018-01-03])
  end

  test "todo_crud" do
    list =
      Todo.List.new()
      |> Todo.List.add_entry(%{date: ~D[2018-01-01], title: "Dinner"})
      |> Todo.List.add_entry(%{date: ~D[2018-01-02], title: "Dentist"})
      |> Todo.List.add_entry(%{date: ~D[2018-01-02], title: "Meeting"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Updated"}] ==
             list
             |> Todo.List.update_entry(1, fn entry -> %{entry | title: "Updated"} end)
             |> Todo.List.entries(~D[2018-01-01])

    assert [] ==
             list
             |> Todo.List.delete_entry(1)
             |> Todo.List.entries(~D[2018-01-01])
  end

  test "todo_builder" do
    list =
      Todo.List.new([
        %{date: ~D[2018-01-01], title: "Dinner"},
        %{date: ~D[2018-01-02], title: "Dentist"},
        %{date: ~D[2018-01-02], title: "Meeting"}
      ])

    assert [%{date: ~D[2018-01-01], id: 1, title: "Dinner"}] ==
             Todo.List.entries(list, ~D[2018-01-01])

    assert [] == Todo.List.entries(list, ~D[2018-01-03])
  end

  test "todo_import" do
    list = Todo.List.CsvImporter.import("#{__DIR__}/todos.csv")

    assert [%{date: ~D[2018-12-20], id: 2, title: "Shopping"}] ==
             Todo.List.entries(list, ~D[2018-12-20])
  end
end
