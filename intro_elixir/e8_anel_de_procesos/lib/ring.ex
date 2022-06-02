defmodule Ring do

  def start(n, m, msg) do
    pid = spawn(__MODULE__, :create_processes, [n, m, msg])
    if Process.register(pid, :home), do: :ok
  end

  def create_processes(n, m, msg) when n > 1 do
    pid = spawn(__MODULE__, :create_processes, [n - 1, m, msg])
    loop(pid)
  end
  def create_processes(1, m, msg) do
    send(:home, {m - 1, msg})
    loop(Process.whereis(:home))
  end

  defp loop(pid) do
    receive do
      {0, _} -> send(pid, :stop)
      {m, msg} ->
        send(pid, {m - 1, msg})
        loop(pid)
      :stop -> send(pid, :stop)
    end
  end

end
