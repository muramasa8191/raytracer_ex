defmodule RaytracerEx do
  @moduledoc """
  Documentation for RaytracerEx.
  """

  @doc """
  Hello world.
  https://qiita.com/mebiusbox2/items/89e2db3b24e4c39502fe
  ## Examples

      iex> RaytracerEx.hello()
      :world

  """
  def hello do
    :world
  end

  def test(w, h) do
    _test(h, w, h, [])
  end
  def _test(0, width, height, arr) do
    {0, arr}
  end
  def _test(y, width, height, arr) do
    {_, array} = 
    List.duplicate([], width)
    |> Enum.reduce({0, []}, fn (_x, {idx, arr}) -> {idx + 1, [[idx / width * 255, y / height * 255, 127]]++arr} end)

    _test(y - 1, width, height, [array]++arr)
  end
  def show_color(w, h, r, g, b) do
    arr = List.duplicate(List.duplicate([r, g, b], w), h)

    { :ok, py_exec } = :python.start( [ python_path: 'lib' ] )
    :python.call( py_exec, :image, :show, [arr] )
    :python.stop( py_exec )

  end
  def show(arr) do
    { :ok, py_exec } = :python.start( [ python_path: 'lib' ] )
    :python.call( py_exec, :image, :show, [arr] )
    :python.stop( py_exec )
  end
end
