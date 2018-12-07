defmodule RaytracerEx.Sphere do
  @name :sphere

  # alias __MODULE__, as: Sphere
  alias RaytracerEx.Vector.Vec3, as: Vec3
  alias RaytracerEx.HitRec, as: HitRec
  alias RaytracerEx.Ray, as: Ray
  
  defstruct type: @name, r: 0.0, center: %Vec3{}

  def hit(shpere, ray, t_min, t_max) do
    oc = Vec3.sub(ray.pos, shpere.center)
    a = Vec3.dot(ray.dir, ray.dir)
    b = Vec3.dot(oc, ray.dir)
    c = Vec3.dot(oc, oc) - shpere.r * shpere.r
    disc = b * b - a * c

    if disc > 0.0 do
      root = :math.sqrt(disc)
      t = (-b - root) / a
      if t_min < t and t < t_max do
        pos = Ray.at(ray, t)
        {true, HitRec.new(t, pos, Vec3.div(Vec3.sub(pos, shpere.center), shpere.r))}
      else
        t = (-b + root) / a
        if t_min < t and t < t_max do
          pos = Ray.at(ray, t)
          {true, HitRec.new(t, pos, Vec3.div(Vec3.sub(pos, shpere.center), shpere.r))}
        else
          {false, nil}
        end            
      end
    else
       {false, nil}
    end
  end
end