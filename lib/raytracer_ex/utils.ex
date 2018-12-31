defmodule RaytracerEx.Utils do
  alias RaytracerEx.Vector.Vec3, as: Vec3
  def radians(deg) do
    deg / 180.0 * :math.pi
  end
  def reflect(vec, normal) do
    Vec3.sub(vec, Vec3.scale(normal, Vec3.dot(vec, normal) * 2.0))
  end
  def refract(vec, normal, ni_over_nt) do
    uv = Vec3.unit_vector(vec)
    dt = Vec3.dot(uv, normal)
    discriminant = 1.0 - ni_over_nt * ni_over_nt * (1.0 - dt * dt)
    if (discriminant > 0.0) do
      refracted = Vec3.sub(Vec3.scale(Vec3.sub(uv, Vec3.scale(normal, dt)), ni_over_nt), Vec3.scale(normal, :math.sqrt(discriminant)))
      {true, refracted}
    else
      {false, nil}
    end
  end
end