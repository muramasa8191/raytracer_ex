defmodule RaytracerEx.HitRec do
  alias __MODULE__, as: HitRec
  alias RaytracerEx.Vector.Vec3, as: Vec3
  alias RaytracerEx.Material.Lambertian, as: Lambertian
  defstruct t: 0.0, pos: %Vec3{}, normal: %Vec3{}, material: %Lambertian{}

  def new(t, p, n, mat) do
    %HitRec{t: t, pos: p, normal: n, material: mat}
  end
end