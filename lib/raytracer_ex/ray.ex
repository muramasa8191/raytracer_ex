defmodule RaytracerEx.Ray do
  alias RaytracerEx.Vector.Vec3, as: Vec3
  defstruct pos: %Vec3{}, dir: %Vec3{}

  def at(vec, t), do: Vec3.add(vec.pos, (Vec3.scale(vec.dir, t)))
  defp _random_vector, do: %Vec3{x: :rand.uniform(), y: :rand.uniform(), z: :rand.uniform() }
  def random_in_unit_sphere() do
    p = Vec3.sub(Vec3.scale(_random_vector, 2.0), Vec3.ones())
    if Vec3.lengthSqr(p), do: p, else: random_in_unit_sphere()
  end
end