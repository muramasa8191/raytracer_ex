defmodule RaytracerEx.Material do
  alias RaytracerEx.Vector.Vec3, as: Vec3
  alias RaytracerEx.Ray, as: Ray
  defmodule Lambertian do
    defstruct albedo: %Vec3{}
    def scatter(lam, ray, hitrec, scatrec) do
      target = Vec3.add(Vec3.add(hitrec.pos, hitrec.normal), Ray.random_in_unit_sphere())
    end
  end
end