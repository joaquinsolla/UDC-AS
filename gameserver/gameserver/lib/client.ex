defmodule Client do

  @moduledoc """
  Cada 'jugador' individual que se conecta al servidor.

  La conexión comienza llamando a la función main():
   - Primero ejecuta connect_server() de forma que se envía al directorio la petición de conexión.
     Una vez enviada la peitición el cliente se queda esperando a recibir el mensaje  con la lista
     de juegos disponibles para jugar, esto significa que se ha establecido la conexión entre el
     cliente y el servidor.
   - A continuación el cliente selecciona un juego mediante select_game(), en donde introduce por
     terminal el juego al que desea jugar.
   - Cuando ya se ha seleccionado un juego, se mueve al cliente a una sala de emparejamiento donde
     se le conectará con un rival (otro cliente). Cuando se le ha encontrado un contricante se les
     devuelve a ambos clientes el room_id que tienen asignado y el juego comienza.
   - La función wait_connection(), donde el cliente espera por un rival, dispone de un timeout. Una
     vez vencido el timeout, se preguntará al jugador si desea seguir esperando o si desea salir al
     menú. El cliente responde por terminal.
   - Una vez finalizado el juego, los clientes se quedan esperando los resultados con wait_results().
     Cuando reciben el resultado de la partida regresan al menú.

  El paso de mensajes se produce entre el cliente y el directorio.
  """

  @doc """
  Bucle principal de ejecución del cliente.
  """
  def main() do
    connect_server()
    game_selected = select_game()
    IO.puts("Esperando al contrincante...\n")
    room_id = wait_connection(game_selected)
    case room_id do
      :exit -> main()
      _ -> send_input(game_selected,room_id)
            IO.puts("Esperando input de tu contrincante...\n")
            wait_results(game_selected,room_id)
            main()
    end
  end

  @doc """
  Conecta con el servidor de juegos e imprime por pantalla el mensaje
  enviado por el servidor que contiene la lista de juegos disponibles
  """
  def connect_server() do
    GenServer.cast({:global, :directorio}, {:login, self()})
    receive do
      msg_game_list ->
        IO.puts(msg_game_list)
    end
  end

  @doc """
  Lee por pantalla la eleeción del jugador y envía al servidor esta selección
  para conectarse al juego seleccionado. Devuelve la selección del usuario.
  """
  defp select_game() do
    input = IO.gets("Jugar a: ")
    {parsedInput,_} = Integer.parse(String.trim(input))
    GenServer.cast({:global, :directorio},{:init_game, parsedInput, self()})
    parsedInput
  end


  @doc """
  Espera el mensaje del servidor que contiene el id de la sala de juego a la que 
  se ha conectado el jugador. Tiene un timeout de 10 segundos en caso de que
  no haya otros jugadores para hacer el emparejamiento. Devuelve el id de la sala.

  ## Parameters
    - game_id : el identificador del juego seleccionado por el usuario.
  """
  defp wait_connection(game_id) do
    receive do
      {room_id, msg_inicio} -> IO.puts(msg_inicio)
                                room_id
      after 10_000 -> IO.puts("Nadie quiere jugar a este juego ahora, intentalo más tarde")
                    GenServer.cast({:global, :directorio},{:log_off, game_id, self()})
                    :exit
    end
  end

  @doc """
  Se lee por pantalla la input del jugador para el juego y se envía al servidor de juego

  ## Parameters
    - game_sel : el identificador del juego seleccionado por el usuario.
    - room_id : el identificador de la sala asignada al usuario.
  """
  defp send_input(game_sel,room_id) do
        input = IO.gets("") |> String.trim
        GenServer.cast({:global,:directorio},{:play_game,game_sel,self(),room_id,input})
  end

  @doc """
  Espera al mensaje del servidor diciendo si ha ganado o perdido y lo printa por pantalla.
  En caso de que el compañero abandone la partida también se comunica. Esta función 
  espera un máximo de 20 segundos antes de determinar que el compañero se ha desconectado.

  ## Parameters
    - game_id : el identificador del juego seleccionado por el usuario.
    - room_id : el identificador de la sala asignada al usuario.
  """
  defp wait_results(game_id,room_id) do
    receive do
      result ->
        IO.puts(result)
      {:exit,msg} ->
        IO.puts(msg)
      after 20_000 -> IO.puts("Parece que tu compañero se ha desconectado de la partida, vuelve a intentarlo")
                      GenServer.cast({:global, :directorio},{:disconnect, game_id, room_id, self()})
    end
  end

end
