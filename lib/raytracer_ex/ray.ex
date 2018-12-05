defmodule RaytracerEx.Ray do
  alias RaytracerEx.Vector.Vec3, as: Vec3
  defstruct pos: %Vec3{}, dir: %Vec3{}

  def at(vec, t), do: Vec3.add(vec.pos, (Vec3.scale(vec.dir, t)))
  
end