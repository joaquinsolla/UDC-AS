defmodule GameServiceFuns do
    @moduledoc """
    
        Módulo de funciones para la gestión de lista de espera y salas
        de juego, de las que hacen uso los servidores de juegos.

    """

    @doc """
    Busca en la lista de salas de juego, la sala a actualizar e introduce el input del
    usuario en la sala correspondiente. Devuelve la lista de salas actualizada

    ## Parameteres:
        - rooms_head : primera parte de una lista auxiliar en la que se va volcando la lista de salas que no coinciden con la sala especificada.
        - rooms_tail : la lista que contiene el resto de salas a comprobar si coinciden con el room_id
        - input : el input que envió el jugador
        - room_id : el identificador de la sala a actualizar.
    """
    def update_room(rooms_head,rooms_tail,input,room_id) when hd(hd(rooms_tail)) == room_id, do: rooms_head ++ [(hd(rooms_tail)++[input])] ++ tl(rooms_tail)
    def update_room(rooms_head,rooms_tail,input,room_id) when hd(hd(rooms_tail)) != room_id, do: update_room(rooms_head++[hd(rooms_tail)],tl(rooms_tail),input,room_id)

    @doc """
    Busca la sala con el id especificado y la borra de la lista de salas. Devuelve la lista de salas
    sin la sala borrada.

    # Parameters:
        - rooms_head : primera parte de una lista auxiliar en la que se va volcando la lista de salas que no coinciden con la sala especificada.
        - rooms_tail : la lista que contiene el resto de salas a comprobar si coinciden con el room_id.
        - room_id : el identificador de la sala a borrar
    """
    def delete_room(rooms_head, rooms_tail, room_id) when hd(hd(rooms_tail)) == room_id, do: rooms_head ++ tl(rooms_tail)
    def delete_room(rooms_head, rooms_tail, room_id) when hd(hd(rooms_tail)) != room_id, do: delete_room(rooms_head++[hd(rooms_tail)], tl(rooms_tail),room_id)


    @doc """
    Busca una sala en la lista de salas y la devuelve.

    #Parameteres:
        - rooms : lista de salas
        - room_id : identificador de la sala a buscar
    """
    def find_room([[head|tail1]|tail2], room_id) when room_id == head, do: [head|tail1]
    def find_room([[head|tail1]|tail2], room_id) when room_id != head, do: find_room(tail2,room_id)
    def find_room([],room_id), do: []

    @doc """
    Dada una sala y un pid, devuelve el pid del jugador contrincante.

    #Parameters:
        - room : la sala de la partida
        - pid_player : el jugador del que queremos saber su contrincante
    """
    def find_partner([room_id, pid1, pid2,_], pid1),do: pid2
    def find_partner([room_id, pid1, pid2,_], pid2),do: pid1

end