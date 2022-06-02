defmodule Effects do

  def print(0), do: IO.puts "#{}"
  def print(n), do: print_aux(n, 1)

  def print_aux(n, n), do: IO.puts "#{n}"
  def print_aux(n, c) do
    IO.puts "#{c}"
    print_aux(n, c + 1)
  end

  def even_print(0), do: IO.puts "#{}"
  def even_print(1), do: IO.puts "#{}"
  def even_print(n), do: even_print_aux(n, 2)

  def even_print_aux(n, n), do: IO.puts "#{n}"
  def even_print_aux(n, c) when c < n do
    IO.puts "#{c}"
    even_print_aux(n, c + 2)
  end
  def even_print_aux(n, c) when c > n do
  end

end

#Effects.print(11)
#Effects.even_print(11)