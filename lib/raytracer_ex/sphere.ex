defmodule RaytracerEx.Sphere do
  @name :sphere

  # alias __MODULE__, as: Sphere
  alias RaytracerEx.Vector.Vec3, as: Vec3
  alias RaytracerEx.HitRec, as: HitRec
  alias RaytracerEx.Ray, as: Ray
  alias RaytracerEx.Material.Lambertian, as: Lambertian

  defstruct type: @name, r: 0.0, center: %Vec3{}, material: %Lambertian{}

  def hit(sphere, ray, t_min, t_max) do
    oc = Vec3.sub(ray.pos, sphere.center)
    a = Vec3.dot(ray.dir, ray.dir)
    b = Vec3.dot(oc, ray.dir)
    c = Vec3.dot(oc, oc) - sphere.r * sphere.r
    disc = b * b - a * c

    if disc > 0.0 do
      root = :math.sqrt(disc)
      t = (-b - root) / a
      if t_min < t and t < t_max do
        pos = Ray.at(ray, t)
        {true, HitRec.new(t, pos, Vec3.div(Vec3.sub(pos, sphere.center), sphere.r), sphere.material)}
      else
        t = (-b + root) / a
        if t_min < t and t < t_max do
          pos = Ray.at(ray, t)
          {true, HitRec.new(t, pos, Vec3.div(Vec3.sub(pos, sphere.center), sphere.r), sphere.material)}
        else
          {false, nil}
        end            
      end
    else
       {false, nil}
    end
  end
end