defmodule Manipulating do

  def filter([], n), do: []
  def filter(l, n), do: filter_aux(l, n, [])

  defp filter_aux([], n, sol), do: reverse(sol)
  defp filter_aux([h | t], n, sol) when h <= n, do: filter_aux(t, n, [h | sol])
  defp filter_aux([h | t], n, sol) when h > n, do: filter_aux(t, n, sol)

  def reverse([]), do: []
  def reverse(l), do: reverse_aux(l, [])

  defp reverse_aux([], sol), do: sol
  defp reverse_aux([h | t], sol), do: reverse_aux(t, [h | sol])

  def concatenate([]), do: []
  def concatenate(l), do: concatenate_aux(l, [])

  defp concatenate_aux([], sol), do: reverse(sol)
  defp concatenate_aux([[] | t], sol), do: concatenate_aux(t, sol)
  defp concatenate_aux([h | t], sol), do: concatenate_aux([(tl h) | t], [(hd h) | sol])

  def flatten(list), do: flatten_aux(list, [])

  defp flatten_aux([h | t], l) when h == [], do: flatten_aux(t, l)
  defp flatten_aux([h | t], l) when is_list(h), do: flatten_aux(h, flatten_aux(t, l))
  defp flatten_aux([h | t], l), do: [h | flatten_aux(t, l)]
  defp flatten_aux([], l), do: l

end

#IO.inspect Manipulating.filter([1,2,3,4,1,5,6], 3)
#IO.inspect Manipulating.reverse([1,2,3,4,1,5,6])
#IO.inspect Manipulating.concatenate([[1,2],[3,4,"a"],[5]])
#IO.inspect Manipulating.flatten([1, 2, [3, [4, [5, 55], []]], [6], 7])