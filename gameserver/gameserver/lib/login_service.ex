defmodule LoginService do
    use GenServer

    @game_list "Bienvenido a Game Server!\nA que juego quieres jugar?\n1-Piedra, papel o tijeras\n2-Pares o nones\n(introduce un número)"

    def start_link(_) do
        GenServer.start_link(__MODULE__,[], name: {:global, :login})
    end

    def init(_) do
        {:ok,[]}
    end

    def handle_cast({:login,pid_player},_) do
        IO.inspect(pid_player)
        GenServer.cast({:global,:directorio},{:communicate_player,pid_player,@game_list})
        {:noreply, []}
    end

end