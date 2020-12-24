defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    GenServer.cast(choose_worker(key), {:store, key, data})
  end
  
  def get(key) do
    GenServer.call(choose_worker(key), {:get, key})
  end

  @impl GenServer
  def init(_) do
    {:ok, start_workers()}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _, pool) do
    {
      :reply,
      Map.get(pool, :erlang.phash2(key, 3)),
      pool
    } 
  end

  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key}) 
  end

  defp start_workers() do
    for x <- 0..2, into: %{} do
      {_, pid} = Todo.DatabaseWorker.start(@db_folder)
      {x, pid}
    end
  end
end
