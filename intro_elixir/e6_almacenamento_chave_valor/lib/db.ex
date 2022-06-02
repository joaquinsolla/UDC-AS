defmodule Db do

  def new(), do: []

  def write([], key, element), do: [{key, element}]
  def write([{key, _} | t], key, element), do: [{key, element} | t]
  def write([h | t], key, element), do: aux_write([h], t, key, element)

  defp aux_write(checked, [], key, element), do: checked ++ [{key, element}]
  defp aux_write(checked, [{key, _} | t], key, element), do: checked ++ [{key, element}] ++ t
  defp aux_write(checked, [h | t], key, element), do: aux_write(checked ++ [h], t, key, element)

  def delete([], key), do: []
  def delete([{key, _} | t], key), do: t
  def delete([h | t], key), do: aux_delete([h], t, key)

  defp aux_delete(checked, [], key), do: checked
  defp aux_delete(checked, [{key, _} | t], key), do: checked ++ t
  defp aux_delete(checked, [h | t], key), do: aux_delete(checked ++ [h], t, key)

  def read([], key), do: {:error, :not_found}
  def read([{key, _} = h | t], key), do: {:ok, h |> elem(1)}
  def read([h | t], key), do: aux_read(t, key)

  defp aux_read([], key), do: {:error, :not_found}
  defp aux_read([{key, _} = h | t], key), do: {:ok, h |> elem(1)}
  defp aux_read([h | t], key), do: aux_read(t, key)

  def match([], element), do: []
  def match([{_, element} = h | t], element), do: aux_match(t, element, [h |> elem(0)])
  def match([h | t], element), do: aux_match(t, element, [])

  defp aux_match([], element, keys), do: keys
  defp aux_match([{_, element} = h | t], element, keys), do: aux_match(t, element, keys ++ [h |> elem(0)])
  defp aux_match([h | t], element, keys), do: aux_match(t, element, keys)

  def destroy(db_ref), do: :ok

end

#IO.inspect Db.new()
#IO.inspect Db.write([{:adios, [0, "a"]},{:uno, [1, "unooo"]}], :uno, [1,2,3])
#IO.inspect Db.delete([{:adios, [1, 2, 3]}, {:ola,[4, 5, 6]}], :ola)
#IO.inspect Db.read([{:adios, [0, 0, 7]}, {:adios, [0, 0, 8]}, {:ola, [1, 2, 3]}, {:ola, [4, 5, 6]}], :ola)
#IO.inspect Db.match([{:adios1, [1, 2, 3]}, {:adios2, [0, 0, 8]}, {:ola1, [1, 2, 3]}, {:ola2, [1, 2, 3]}], [1, 2, 3])
#IO.inspect Db.destroy([1])