defmodule PipelineEcho do

  def start(n) do
    IO.puts('- ECHO INICIADO\n')

    pid0 = spawn(fn -> start_aux() end)
    Process.register(pid0, :start)

    pid1 = spawn(fn -> msg_creation() end)
    Process.register(pid1, :creation)

    pid2 = spawn(fn -> msg_processing() end)
    Process.register(pid2, :processing)

    pid3 = spawn(fn -> msg_print() end)
    Process.register(pid3, :print)

    send(:start, {n,n})
  end

  defp start_aux() do
    receive do
      {1, m} ->
        send(:creation, {1,m})
      {n, m} ->
        send(:creation, {n,m})
        send(:start, {n-1,m})
        start_aux()
    end
  end

  defp msg_creation() do
    receive do
      {1, m} ->
        msg = "Mensaje #{inspect(m)}"
        send(:processing, {msg, :end})
      {n, m} ->
        msg = "Mensaje #{inspect(m-n+1)}"
        send(:processing, msg)
        msg_creation()
    end
  end

  defp msg_processing() do
    receive do
      {msg, :end} ->
        gsm = String.reverse(msg)
        new_msg = "#{msg} | #{gsm}"
        send(:print, {new_msg, :end})
      msg ->
        gsm = String.reverse(msg)
        new_msg = "#{msg} | #{gsm}"
        send(:print, new_msg)
        msg_processing()
    end
  end

  defp msg_print() do
    receive do
      {msg, :end} ->
        IO.puts(msg)
        IO.puts('\n- ECHO FINALIZADO')
        :ok
      msg ->
        IO.puts(msg)
        msg_print()
    end
  end

end

# EJECUCION
PipelineEcho.start(10)