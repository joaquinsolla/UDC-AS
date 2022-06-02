defmodule PiedraPapelTijerasSupervisor do
    use Supervisor
  
    def start_link(_) do
      Supervisor.start_link(__MODULE__, [], [])
    end
  
    def init([]) do
      children = [
        {GamePiedrapapeltijeras,[]}
      ]
  
      Supervisor.init(children, strategy: :one_for_one)
    end
  end
  