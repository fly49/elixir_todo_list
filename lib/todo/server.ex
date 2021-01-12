defmodule Todo.Server do
  use GenServer, restart: :temporary
  alias Todo.{List, Database}
  
  def start_link(name) do
    GenServer.start_link(
      Todo.Server,
      name,
      name: via_tuple(name)
    )
  end

  def via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  @impl GenServer
  def init(list_name) do
    IO.puts("Starting to-do server for #{list_name}.")
    todo_list = Database.get(list_name) || List.new()
    {:ok, {list_name, todo_list}}
  end

  @impl GenServer
  def handle_cast({:add_entry, entry}, {name, todo_list}) do
    new_list = List.add_entry(todo_list, entry)
    Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, {name, todo_list}) do
    {
      :reply,
      List.entries(todo_list, date),
      {name, todo_list}
    }
  end
end
