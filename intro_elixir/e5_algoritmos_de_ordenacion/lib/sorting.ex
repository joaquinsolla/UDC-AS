defmodule Sorting do

  def quicksort([]), do: []
  def quicksort(l) do
    {izq, der} = Enum.split_with((tl l), &(&1 < (hd l)))
    quicksort(izq) ++ [(hd l)] ++ quicksort(der)
  end

  def mergesort([]), do: []
  def mergesort([e]), do: [e]
  def mergesort(l) when is_list(l) do
    len = length(l)
    {left, right} = Enum.split(l, div(len, 2))
    left = mergesort(left)
    right = mergesort(right)
    merge(left, right, [])
  end

  defp merge([], right, l), do: Enum.reverse(l) ++ right
  defp merge(left, [], l), do: Enum.reverse(l) ++ left
  defp merge([left_h | left_t], [right_h | right_t], l) when left_h <= right_h, do: merge(left_t, [right_h | right_t], [left_h | l])
  defp merge([left_h | left_t], [right_h | right_t], l) when left_h > right_h, do: merge([left_h | left_t], right_t, [right_h | l])

end

#IO.inspect Sorting.quicksort([1, 4, 2, 5, 6, 3, -1, 2, 6, 8, 4, 1])
#IO.inspect Sorting.mergesort([1, 4, 2, 5, 6, 3, -1, 2, 6, 8, 4, 1])