defmodule Boolean do

  def b_not(true), do: false
  def b_not(false), do: true

  def b_and(true, true), do: true
  def b_and(_, _), do: false

  def b_or(false, false), do: false
  def b_or(_, _), do: true

end

#PRUEBAS
#IO.inspect Boolean.b_not(true)
#IO.inspect Boolean.b_and(true, false)
#IO.inspect Boolean.b_or(false, false)
