defmodule RaytracerEx.Material do
  alias RaytracerEx.Vector.Vec3, as: Vec3
  alias RaytracerEx.Ray, as: Ray
  alias RaytracerEx.Utils, as: Utils
  defmodule Lambertian do
    @name :lambertian
    defstruct type: @name, albedo: %Vec3{}
    def scatter(lam, ray, hitrec) do
      target = Vec3.add(Vec3.add(hitrec.pos, hitrec.normal), Ray.random_in_unit_sphere())

      {true, %Ray{pos: hitrec.pos, dir: Vec3.sub(target, hitrec.pos)}, lam.albedo}
    end
  end
  defmodule Metal do
    @name :metal
    defstruct type: @name, albedo: %Vec3{}, fuzz: 1.0
    def scatter(metal, ray, hitrec) do
      reflected = Utils.reflect(Vec3.normalize(ray.dir), hitrec.normal)
      scattered = %Ray{pos: hitrec.pos, dir: Vec3.add(reflected, Vec3.scale(Ray.random_in_unit_sphere(), metal.fuzz))}
      {(Vec3.dot(scattered.dir, hitrec.normal) > 0.0), scattered, metal.albedo}
    end
  end

  def scatter(material, ray, hitrec) do
    case material.type do
      :lambertian -> Lambertian.scatter(material, ray, hitrec)
      :metal      -> Metal.scatter(material, ray, hitrec)
    end
  end
end