defmodule Create do

  def create(0), do: []
  def create(n), do: create_aux(n-1, [n])

  defp create_aux(0, l), do: l
  defp create_aux(n, l), do: create_aux(n-1, [n | l])

  def reverse_create(0), do: []
  def reverse_create(1), do: [1]
  def reverse_create(n), do: [n | reverse_create(n-1)]

end

#IO.inspect Create.create(11)
#IO.inspect Create.reverse_create(11)