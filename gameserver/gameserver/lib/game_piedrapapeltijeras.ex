defmodule GamePiedrapapeltijeras do
    use GenServer
    import GameServiceFuns

    @moduledoc """
    Los jugadores entran en la sala para jugar al juego. Si solo hay un jugador, este esperaria a que
    otro entrase en la sala (funcion handle_cast()).
    El servicio comienza una vez los 2 jugadores estan listos para jugar:
        - Una vez iniciado el juego, se le pide por pantalla a cada jugador su opcion a jugar, ya sea
        piedra, papel o tijera
        - Una vez cada jugador haya seleccionado su opción, se llama a la funcion calculate_winner(), la
        cual compara las opciones de cada jugador y le asigna a cada jugador si es el ganador o el perdedor
        - Para finalizar, una vez calculado el ganador, la funcion manage_room() se encarga de asignar los textos
        a cada jugador
        - También puede haber la posibilidad de que ambos jugadores saquen la misma opción. Esta posibilidad las
        tenemos en cuenta en todas las funciones mencionadas anteriormente
    El paso de mensajes se produce entre el servicio y el cliente, pero para que esto sea posible, el directorio
    hace de intermediario entre ambos.
    """

    @piedra "1"
    @papel "2"
    @tijeras "3"
    @msg_game "\nHola, bienvenido a Piedra, Papel o Tijeras, introduce tu input para jugar\n1-piedra\n2-papel\n3-tijeras\n"

    def start_link(_) do
        GenServer.start_link(__MODULE__,[[],[]], name: {:global, :piedrapapel})
    end


    def init([players,rooms]) do
        {:ok, [players,rooms]}
    end



    def handle_cast({:add_player, pid_player}, [players,[]]) when length(players) == 1 do
        #mandar 1- piedra 2- papel 3-tijeras
        GenServer.cast({:global,:directorio},{:communicate_player,pid_player,{1,@msg_game}})
        GenServer.cast({:global,:directorio},{:communicate_player,hd(players),{1,@msg_game}})
        {:noreply, [[],[[1,pid_player,hd(players)]]]}
    end



    def handle_cast({:add_player, pid_player}, [players,rooms]) when length(players) == 1 do
        #mandar 1- piedra 2- papel 3-tijeras
        GenServer.cast({:global,:directorio},{:communicate_player,pid_player,{hd(hd(rooms))+1,@msg_game}})
        GenServer.cast({:global,:directorio},{:communicate_player,hd(players),{hd(hd(rooms))+1,@msg_game}})
        {:noreply, [[],[[hd(hd(rooms))+1,pid_player,hd(players)]]++rooms]}
    end

    def handle_cast({:add_player, pid_player}, [players,rooms]) do
        {:noreply, [[pid_player|players],rooms]}
    end



    def handle_cast({:receive_input,input,pid_player,room_id}, [players,rooms]) do
        room = find_room(rooms,room_id)
        case room do
            [] -> {:noreply,[players,rooms]}
            _  -> room_action = manage_room(room ++ [{pid_player,input}])
                  case room_action do
                    :delete -> {:noreply, [players,delete_room([],rooms,room_id)]}
                    :nothing -> {:noreply,[players, update_room([],rooms,{pid_player,input},room_id)]}
                  end
        end
    end



    def handle_cast({:log_off,pid_player}, [players,rooms]) do
        {:noreply,[[],rooms]}
    end



    def handle_cast({:disconnect,room_id,pid_player}, [players,rooms])do
        room = find_room(rooms,room_id)
        pid_partner = find_partner(room,pid_player)
        GenServer.cast({:global,:directorio},{:communicate_player,pid_partner,{:exit,"Tu compañero se ha desconectado."}})
        {:noreply,[players,delete_room([],rooms,room_id)]}
    end


    def handle_cast(:delete_state, [_,_]), do: {:noreply,[[],[]]}

    def handle_call(:get_state,from,[players,rooms]) do
        {:reply,{players,rooms},[players,rooms]}
    end

    @doc """
    manage_room -> gestiona las salas de juego cuando un usuario envía un input.

    ## Parameters
        - room : una lista que representa una sala de juego que contiene, id, pids de los jugadores
          e inputs de estos.
    """

    def manage_room(room) when length(room) == 4 do
        :nothing
    end

    def manage_room([room_id,_,_,{pid_player1,input1},{pid_player2,input2}]) do
        {pid_winner,pid_looser} = calculate_winner({pid_player1,input1},{pid_player2,input2})
        case pid_winner do
            :empate -> GenServer.cast({:global,:directorio},{:communicate_player,pid_player1,"Habeis Empatado!"})
                        GenServer.cast({:global,:directorio},{:communicate_player,pid_player2,"Habeis Empatado!"})

            _ -> GenServer.cast({:global,:directorio},{:communicate_player,pid_winner,"Has Ganado!!! :)"})
                GenServer.cast({:global,:directorio},{:communicate_player,pid_looser,"Has Perdido. :("})
        end
        :delete
    end

    @doc """
    Calcula el ganador segun sus inputs y devuelve el pid del ganador

    ## Parameters

        - {pid_player1, input1}: opcion que escoge el jugador1 para jugar
        - {pid_player2, input2}: opcion que escoge el jugador2 para jugar

    """

    def calculate_winner({pid_player1, input1}, {pid_player2, input2}) when input1 == input2 do
        {:empate, :empate}
    end

    def calculate_winner({pid_player1, @piedra}, {pid_player2, @tijeras}) do
        {pid_player1,pid_player2}
    end

    def calculate_winner({pid_player1, @tijeras}, {pid_player2, @papel}) do
        {pid_player1,pid_player2}
    end

    def calculate_winner({pid_player1, @papel}, {pid_player2, @piedra}) do
        {pid_player1,pid_player2}
    end

    def calculate_winner({pid_player1, _}, {pid_player2, _}) do
        {pid_player2,pid_player1}
    end

end
