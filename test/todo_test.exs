defmodule TodoTest do
  use ExUnit.Case
  #doctest Todo

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
end
