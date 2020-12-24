defmodule Todo.DatabaseWorker do
  use GenServer

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder)
  end

  def store(pid, key, data) do
    GenServer.cast(pid, {:store, key, data})
  end
  
  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  @impl GenServer
  def init(folder) do
    {:ok, folder}    
  end
  
  @impl GenServer
  def handle_cast({:store, key, data}, folder) do
    spawn(fn ->
      key
      |> file_name(folder)
      |> File.write!(:erlang.term_to_binary(data))
    end)

    {:noreply, folder}
  end

  @impl GenServer
  def handle_call({:get, key}, caller, folder) do
    spawn(fn ->
      data = case File.read(file_name(key, folder)) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _ -> nil
      end

      GenServer.reply(caller, data)
    end)

    {:noreply, folder}
  end

  defp file_name(key, folder) do
    Path.join(folder, to_string(key))
  end
end