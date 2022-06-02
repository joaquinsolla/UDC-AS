defmodule Directory do
    use GenServer


    @moduledoc """
    Sirve para establecer las comunicaciones entre el cliente y los diferentes
    servicios (login, juego de piedra papel o tijeras y juego de pares o nones).

    Le traslada al servicio correspondiente las solicitudes del cliente:
        - Cuando este desea entrar al servidor se le comunica al servicio de
          login para que este devuelva la lista de juegos.
        - Cuando selecciona un videojuego, envía al servicio correspondiente
          la señal de que debe añadir un jugador a sus salas.
        - Cuando ya ha iniciado el juego y el cliente envía su jugada, también
          se traslada al servicio del juego correspondiente.
        - Cuando se acaba el tiempo de espera del cliente para encontrar otro
          jugador, se traslada al juego la señal de salida del jugador
        - Cuando ya se ha iniciado una partida y se acaba el tiempo de espera
          de respuesta del contrincante se traslada al juego la señal de
          desconexión.

    Todas las comunicaciones desde los servicios hacia el cliente se trasladan
    de forma directa sin importar cuál sea el origen ni el mensaje en sí.
    """



    def start_link(_) do
        GenServer.start_link(__MODULE__, [], name: {:global,:directorio})
    end

    

    def init(_) do
        {:ok,[]}
    end



    def handle_cast({:login,pid_player},_) do
        IO.inspect(pid_player)
        GenServer.cast({:global, :login},{:login,pid_player})
        {:noreply,[]}
    end

    def handle_cast({:init_game,1,pid_player},_) do
        GenServer.cast({:global,:piedrapapel},{:add_player,pid_player})
        {:noreply, []}
    end

    def handle_cast({:play_game,1,pid_player,room_id,input},_) do
        GenServer.cast({:global,:piedrapapel},{:receive_input,input,pid_player,room_id})
        {:noreply, []}
    end

    def handle_cast({:init_game,2,pid_player},_) do
        GenServer.cast({:global,:paresnones},{:add_player,pid_player})
        {:noreply, []}
    end

    def handle_cast({:play_game,2,pid_player,room_id,input},_) do
        GenServer.cast({:global,:paresnones},{:receive_input,input,pid_player,room_id})
        {:noreply, []}
    end

    def handle_cast({:log_off, 1, pid_player},_) do
        GenServer.cast({:global,:piedrapapel},{:log_off,pid_player})
        {:noreply,[]}
    end

    def handle_cast({:log_off, 2, pid_player},_) do
        GenServer.cast({:global,:paresnones},{:log_off,pid_player})
        {:noreply,[]}
    end

    def handle_cast({:disconnect, 1, room_id, pid_player},_) do
        GenServer.cast({:global,:piedrapapel},{:disconnect,room_id,pid_player})
        {:noreply,[]}
    end

    def handle_cast({:disconnect, 2, room_id, pid_player},_) do
        GenServer.cast({:global,:paresnones},{:disconnect,room_id,pid_player})
        {:noreply,[]}
    end

    def handle_cast({:communicate_player,pid_player,msg},_) do
        send(pid_player,msg)
        {:noreply, []}
    end

end
