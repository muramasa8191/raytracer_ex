defmodule RaytracerEx.Camera do
  alias __MODULE__ , as: Camera
  alias RaytracerEx.Vector.Vec3, as: Vec3
  alias RaytracerEx.Utils, as: Utils
  alias RaytracerEx.Ray, as: Ray
  defstruct origin: %Vec3{}, low_left: %Vec3{}, horizontal: %Vec3{}, vertical: %Vec3{},
     u: %Vec3{}, v: %Vec3{}, w: %Vec3{}, lens_radius: 1.0

  def create(lookfrom, lookat, vup, vfov, aspect, aperture, focus_dist) do
    theta = vfov * :math.pi / 180
    half_height = :math.tan(theta * 0.5)
    half_width = aspect * half_height
    origin = lookfrom
    w = Vec3.normalize(Vec3.sub(lookfrom, lookat))
    u = Vec3.normalize(Vec3.cross(vup, w))
    v = Vec3.cross(w, u)
    lower_left = Vec3.sub(Vec3.sub(Vec3.sub(origin, Vec3.scale(u, focus_dist * half_width)), 
                                   Vec3.scale(v, focus_dist * half_height)),
                          Vec3.scale(w, focus_dist))
    horizontal = Vec3.scale(u, half_width * 2.0 * focus_dist)
    vertical = Vec3.scale(v, half_height * 2.0 * focus_dist)
    %Camera{origin: origin, horizontal: horizontal, vertical: vertical, low_left: lower_left, u: u,  v: v, w: w, lens_radius: aperture * 0.5}
  end

  def get_ray(camera, s, t) do
    rd = Vec3.scale(random_in_unit_disk(), camera.lens_radius)
    offset = Vec3.add(Vec3.scale(camera.u, rd.x), Vec3.scale(camera.v, rd.y))
    dir = Vec3.add(camera.low_left, Vec3.scale(camera.horizontal, s))
    dir = Vec3.add(dir, Vec3.scale(camera.vertical, t))
    dir = Vec3.sub(dir, camera.origin)
    dir = Vec3.sub(dir, offset)

    %Ray{pos: Vec3.add(camera.origin, offset), dir: dir}
  end
  def random_in_unit_disk() do
    p = Vec3.scale(Vec3.sub(Vec3.vec3([:rand.uniform(), :rand.uniform(), 0.0]), Vec3.vec3([1.0, 1.0, 0.0])), 2.0)
    if Vec3.dot(p, p) < 1.0, do: p, else: random_in_unit_disk()
  end
end