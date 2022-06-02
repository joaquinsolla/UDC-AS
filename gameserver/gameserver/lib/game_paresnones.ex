defmodule GameParesnones do
    use GenServer
    import GameServiceFuns

    @moduledoc """
    Servidor de juego de pares o nones. Se encarga de recibir las llamadas de
    inicio de juego por parte de un jugador, recibir las inputs de los jugadores y también
    gestionar tanto listas de espera como listas de las salas en las que se están
    jugando partidas, calcular los resultados de las partidas, y comunicar, por medio del
    directorio, el inicio de partida y los resultados de la misma, así como que el usuario
    contrincante se ha desconectado.
    """

    @pares "p"
    @nones "n"
    @msg_game "Hola, bienvenido a Pares o nones, introduces un número del 1 al 10, un guión, y tu apuesta:\np - par\nn - impar\n(Ejemplo 3-p)\n"

    def start_link(_) do
        GenServer.start_link(__MODULE__,[[],[]], name: {:global, :paresnones})
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

    def handle_cast(:delete_state,[_,_]), do: {:noreply,[[],[]]}



    def handle_call(:get_state,from,[players,rooms]) do
        {:reply,{players,rooms},[players,rooms]}
    end



    @doc """
    manage_room() -> gestiona las salas de juego cuando un usuario envía un input.

    ## Parameters
        - room : una lista que representa una sala de juego que contiene, id, pids de los jugadores
          e inputs de estos.
    """

    def manage_room(room) when length(room) == 4 do
        :nothing
    end

    def manage_room([room_id,_,_,{pid_player1,input1},{pid_player2,input2}]) do
        {pid_winner,pid_looser} = manage_inputs({pid_player1,input1},{pid_player2,input2})
        case pid_winner do
            :empate -> GenServer.cast({:global,:directorio},{:communicate_player,pid_player1,"Habeis Empatado!"})
                        GenServer.cast({:global,:directorio},{:communicate_player,pid_player2,"Habeis Empatado!"})

            _ -> GenServer.cast({:global,:directorio},{:communicate_player,pid_winner,"Has Ganado!!! :)"})
                GenServer.cast({:global,:directorio},{:communicate_player,pid_looser,"Has Perdido. :("})
        end
        :delete
    end


    @doc """
    manage_inputs() -> separa la input de cada usuario para obtener los dos datos que contiene

    ## Parameters

        - player1 : tupla que contiene el pid del jugador 1 y su input
        - player2 : tupla que contiene el pid del jugador 2 y su input


    """
    def manage_inputs({pid_player1, input1}, {pid_player2,input2}) do
        [string_number1,bet1] = String.split(input1,"-")
        {number1,_} = Integer.parse(string_number1)
        [string_number2,bet2] = String.split(input2,"-")
        {number2,_} = Integer.parse(string_number2)
        calculate_winner({pid_player1,bet1},{pid_player2,bet2},number1+number2)
    end


    @doc """
    calculate_winner() -> calcula el ganador segun sus inputs y devuelve el pid del ganador

    ## Parameters

        - {pid_player1, input1}: opcion que escoge el jugador1 para jugar
        - {pid_player2, input2}: opcion que escoge el jugador2 para jugar

    ## Examples

        - input1 == input2 -> Empatan
        - input1 = @piedra, input2 = @tijera -> Gana el jugador 1
        - input1 = @tijera, input2 = @papel -> Gana el jugador 1
        - input1 = @papel, input2 = @piedra -> Gana el jugador 1
        - Cualquier otro resultado -> Gana el jugador 2

    """

    def calculate_winner({pid_player1, bet}, {pid_player2, bet}, _) do
        {:empate, :empate}
    end

    def calculate_winner({pid_player1, @pares}, {pid_player2, @nones}, sum) when rem(sum,2)==0 do
        {pid_player1,pid_player2}
    end

    def calculate_winner({pid_player1, @nones}, {pid_player2, @pares}, sum) when rem(sum,2)!=0 do
        {pid_player1,pid_player2}
    end

    def calculate_winner({pid_player1, _}, {pid_player2, _}, _) do
        {pid_player2,pid_player1}
    end

end
