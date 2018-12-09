defmodule RaytracerEx.Utils do
  alias RaytracerEx.Vector.Vec3, as: Vec3
  def radians(deg) do
    deg / 180.0 * :math.pi
  end
  def reflect(vec, normal) do
    Vec3.sub(vec, Vec3.scale(normal, Vec3.dot(vec, normal) * 2.0))
  end
end