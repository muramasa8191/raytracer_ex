defmodule RaytracerEx.Camera do
  alias __MODULE__ , as: Camera
  alias RaytracerEx.Vector.Vec3, as: Vec3
  alias RaytracerEx.Utils, as: Utils
  alias RaytracerEx.Ray, as: Ray
  defstruct pos: %Vec3{}, uvw: %{u: %Vec3{}, v: %Vec3{}, w: %Vec3{}}

  def create_by_position(u, v, w) do
    %Camera{uvw: %{u: u, v: v, w: w}}
  end
  def create_by_look_at(from, at, up, fov, aspect) do
    half_h = :math.tan(Utils.radians(fov) / 2.0)
    half_w = aspect * half_h
    w = Vec3.normalize(Vec3.sub(from, at))
    u = Vec3.normalize(Vec3.cross(up, w))
    v = Vec3.cross(w, u)

    w2 = Vec3.sub(Vec3.sub(Vec3.sub(from, Vec3.scale(u, half_w)), Vec3.scale(v, half_h)), w)
    %Camera{pos: from, uvw: %{u: Vec3.scale(u, 2.0 * half_w), v: Vec3.scale(v, 2.0 * half_h), w: w2}}
  end

  def getRay(camera, u, v) do
    dir = Vec3.add(camera.uvw[:w], Vec3.scale(camera.uvw[:u], u))
    dir = Vec3.add(dir, Vec3.scale(camera.uvw[:v], v))
    dir = Vec3.sub(dir, camera.pos)

    %Ray{pos: camera.pos, dir: dir}
  end
end