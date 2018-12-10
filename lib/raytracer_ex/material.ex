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
  defmodule Dielectric do
    @name :dielectric
    defstruct type: @name, ri: 1.0
    def scatter(diel, ray, hitrec) do
      reflected = Utils.reflect(ray.dir, hitrec.normal)
      attenuation = Vec3.ones()
      {outward_normal, ni_over_nt, cosine} = parse(diel, ray, hitrec)
      {is_refract, refracted} = Vec3.refract(ray.dir, outward_normal, ni_over_nt)
      reflect_prob = if is_refract, do: schlick(cosine, diel.ri), else: 1.0
      scattered = if :rand.uniform() < reflect_prob, 
                     do: %Ray{pos: hitrec.pos, dir: reflected}, else: %Ray{pos: hitrec.pos, dir: refracted}
      {true, scattered, attenuation}
    end
    def parse(diel, ray, hitrec) do
      if Vec3.dot(ray.dir, hitrec.normal) > 0.0 do
       {Vec3.scale(hitrec.normal, -1.0), diel.ri, (Vec3.dot(ray.dir, hitrec.normal) * diel.ri) / (Vec3.len(ray.dir))}
      else
        {hitrec.normal, 1.0 / diel.ri, (Vec3.dot(ray.dir, hitrec.normal) * -1 * diel.ri) / (Vec3.len(ray.dir))}
      end
    end
    def schlick(cosine, ref_idx) do
      r0 = (1.0 - ref_idx) / (1.0 + ref_idx)
      r0 = r0 * r0
      r0 + (1.0 - r0) * :math.pow((1.0 - cosine), 5)
    end
  end

  def scatter(material, ray, hitrec) do
    case material.type do
      :lambertian -> Lambertian.scatter(material, ray, hitrec)
      :metal      -> Metal.scatter(material, ray, hitrec)
      :dielectric -> Dielectric.scatter(material, ray, hitrec)
    end
  end
end