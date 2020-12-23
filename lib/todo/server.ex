defmodule Todo.Server do
  use GenServer
  alias Todo.List
  
  def start do
    GenServer.start(__MODULE__, nil)
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  @impl GenServer
  def init(_) do
    {:ok, List.new()}
  end

  @impl GenServer
  def handle_cast({:add_entry, entry}, todo_list) do
    {:noreply, List.add_entry(todo_list, entry)}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, todo_list) do
    {:reply, List.entries(todo_list, date), todo_list}
  end
end
