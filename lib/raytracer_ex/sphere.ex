defmodule RaytracerEx.Sphere do
  @name :sphere

  # alias __MODULE__, as: Sphere
  alias RaytracerEx.Vector.Vec3, as: Vec3
  
  defstruct type: @name, r: 0.0, center: %Vec3{}

  def is_hit(shpere, ray) do
    hit(shpere, ray) > 0.0
  end
  def hit(shpere, ray) do
    oc = Vec3.sub(ray.pos, shpere.center)
    a = Vec3.dot(ray.dir, ray.dir)
    b = Vec3.dot(ray.dir, oc) * 2.0
    c = Vec3.dot(oc, oc) - shpere.r * shpere.r
    disc = b * b - 4 * a * c

    if disc > 0, do: (-b - :math.sqrt(disc)) * (a * 0.5), else: -1.0
  end
end