defmodule Echo do

  def start() do
    pid = spawn(fn -> echo_fun() end)
    Process.register(pid, :echo)
    :ok
  end

  defp echo_fun() do
    receive do
      :stop ->
        :ok
      msg ->
        IO.puts msg
        echo_fun()
    end
  end

  def stop() do
    send(:echo, :stop)
    Process.unregister(:echo)
  end

  def print(term), do: send(:echo, term)

end

#IO.inspect Echo.start()

#Echo.print("ola")
#Echo.print("adios")

#IO.inspect Echo.stop()