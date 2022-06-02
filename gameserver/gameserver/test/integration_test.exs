defmodule IntegrationTest do
  use ExUnit.Case

  @game_list "Bienvenido a Game Server!\nA que juego quieres jugar?\n1-Piedra, papel o tijeras\n2-Pares o nones\n(introduce un número)"
  @msg_piedra "\nHola, bienvenido a Piedra, Papel o Tijeras, introduce tu input para jugar\n1-piedra\n2-papel\n3-tijeras\n"
  @msg_pares "Hola, bienvenido a Pares o nones, introduces un número del 1 al 10, un guión, y tu apuesta:\np - par\nn - impar\n(Ejemplo 3-p)\n"

  setup do
    Node.ping(:dir@valtiel)
    :timer.sleep(1000)
    on_exit(fn -> 
      GenServer.cast({:global,:paresnones},:delete_state)
      GenServer.cast({:global,:piedrapapel},:delete_state)
      end)
  end

  test "Test de integración directorio - login" do

    GenServer.cast({:global,:directorio},{:login,self()})
    receive do
      msg_game_list -> assert msg_game_list == @game_list
    end
  end

  test "Test de integración directorio - piedra papel tijeras" do
    GenServer.cast({:global, :directorio},{:init_game, 1, self()})
    :timer.sleep(1000)
    {players,rooms} = GenServer.call({:global,:piedrapapel},:get_state)
    assert players == [self()]
    assert rooms == []

    GenServer.cast({:global, :directorio},{:init_game, 1, self()})
    receive do
      {room_id, msg_inicio} -> assert room_id == 1
                               assert msg_inicio == @msg_piedra
    end
    receive do
      {room_id, msg_inicio} -> assert room_id == 1
                               assert msg_inicio == @msg_piedra
    end
    :timer.sleep(1000)
    {players_after,rooms_after} = GenServer.call({:global,:piedrapapel},:get_state)
    assert players_after == []
    assert rooms_after == [[1,self(),self()]]

    GenServer.cast({:global,:directorio},{:play_game,1,self(),1,"1"})
    :timer.sleep(1000)
    {players_after_input,rooms_after_input} = GenServer.call({:global,:piedrapapel},:get_state)
    assert players_after_input == []
    assert rooms_after_input == [[1,self(),self(),{self(),"1"}]]

    GenServer.cast({:global,:directorio},{:play_game,1,self(),1,"3"})
    :timer.sleep(1000)
    {players_final,rooms_final} = GenServer.call({:global,:piedrapapel},:get_state)
    assert players_final == []
    assert rooms_final == []

    receive do
      result -> assert result == "Has Ganado!!! :)"
    end

  end

  test "Test de integración directorio - pares o nones" do


    GenServer.cast({:global, :directorio},{:init_game, 2, self()})
    :timer.sleep(1000)
    {players,rooms} = GenServer.call({:global,:paresnones},:get_state)

    assert players == [self()]
    assert rooms == []

    GenServer.cast({:global, :directorio},{:init_game, 2, self()})
    
    receive do
      {room_id, msg_inicio} -> assert room_id == 1
                                assert msg_inicio == @msg_pares
    end
    receive do
      {room_id, msg_inicio} -> assert room_id == 1
                                assert msg_inicio == @msg_pares
    end
    {players_after,rooms_after} = GenServer.call({:global,:paresnones},:get_state)
    assert players_after == []
    assert rooms_after == [[1,self(),self()]]

    GenServer.cast({:global,:directorio},{:play_game,2,self(),1,"1-p"})
    :timer.sleep(1000)
    {players_after_input,rooms_after_input} = GenServer.call({:global,:paresnones},:get_state)
    assert players_after_input == []
    assert rooms_after_input == [[1,self(),self(),{self(),"1-p"}]]

    GenServer.cast({:global,:directorio},{:play_game,2,self(),1,"3-n"})
    :timer.sleep(1000)
    {players_final,rooms_final} = GenServer.call({:global,:paresnones},:get_state)

    assert players_final == []
    assert rooms_final == []

    receive do
      result -> assert result == "Has Ganado!!! :)"
    end

  end


  test "Test de error en directorio" do

    GenServer.cast({:global,:directorio},{:no_match,self()})
    :timer.sleep(1000)
    GenServer.cast({:global,:directorio},{:login,self()})
    receive do
      msg_game_list -> assert msg_game_list == @game_list
    end
  end


  test "Test de error en piedra papel tijeras" do
    GenServer.cast({:global,:directorio},{:play_game,1,self(),1,"1"})
    :timer.sleep(1000)
    GenServer.cast({:global, :directorio},{:init_game, 1, self()})
    :timer.sleep(1000)
    {players,rooms} = GenServer.call({:global,:piedrapapel},:get_state)
    assert players == [self()]
    assert rooms == []

    GenServer.cast({:global, :directorio},{:init_game, 1, self()})
    receive do
      {room_id, msg_inicio} -> assert room_id == 1
                               assert msg_inicio == @msg_piedra
    end
    receive do
      {room_id, msg_inicio} -> assert room_id == 1
                               assert msg_inicio == @msg_piedra
    end
    
  end


  test "Test de error en pares o nones" do

    GenServer.cast({:global,:directorio},{:play_game,2,self(),1,"1-p"})
    :timer.sleep(1000)
    GenServer.cast({:global, :directorio},{:init_game, 2, self()})
    :timer.sleep(1000)
    {players,rooms} = GenServer.call({:global,:paresnones},:get_state)

    assert players == [self()]
    assert rooms == []

    GenServer.cast({:global, :directorio},{:init_game, 2, self()})
    
    receive do
      {room_id, msg_inicio} -> assert room_id == 1
                                assert msg_inicio == @msg_pares
    end
    receive do
      {room_id, msg_inicio} -> assert room_id == 1
                                assert msg_inicio == @msg_pares
    end

  end

end
