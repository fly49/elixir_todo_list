defmodule TodoTest.Server do
  use ExUnit.Case

  test "todo_server" do
    Todo.Database.start()
    {:ok, pid} = Todo.Server.start("some_name")
    Todo.Server.add_entry(pid, %{date: ~D[2018-01-01], title: "Dinner"})
    Todo.Server.add_entry(pid, %{date: ~D[2018-01-02], title: "Dentist"})
    Todo.Server.add_entry(pid, %{date: ~D[2018-01-02], title: "Meeting"})

    assert [%{date: ~D[2018-01-01], id: 1, title: "Dinner"}] ==
             Todo.Server.entries(pid, ~D[2018-01-01])
  end

end