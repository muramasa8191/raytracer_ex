defmodule RaytracerEx.Scene do
  alias __MODULE__, as: Scene
  alias RaytracerEx.Vector.Vec3, as: Vec3
  alias RaytracerEx.Ray, as: Ray
  alias RaytracerEx.Sphere, as: Sphere
  alias RaytracerEx.Camera, as: Camera
  
  defstruct nx: 200, ny: 100, camera: %Camera{}, objects: []

  def create_scene(nx, ny, camera) do
    %Scene{nx: nx, ny: ny, camera: camera, objects: []}
  end
  def create_scene(nx, ny, camera, objects) do
    %Scene{nx: nx, ny: ny, camera: camera, objects: objects}
  end

  def add_object(scene, obj) do
    %Scene{scene | objects: [obj]++scene.objects}
  end
  def render(scene) do
    img =
    0..scene.ny-1
    |> Enum.map(fn y ->
      0..scene.nx-1
        |> Enum.map(fn x ->
          u = x / scene.nx
          v = y / scene.ny
          ray = Camera.get_ray(scene.camera, u, v)
          sphere = hd scene.objects
          h = Sphere.hit(sphere, ray)
          if h > 0.0 do
            norm = Vec3.normalize(Vec3.sub(Ray.at(ray, h), sphere.center))
            color = Vec3.scale(Vec3.add(norm, %Vec3{x: 1.0, y: 1.0, z: 1.0}), 127.5)
            [color.x, color.y, color.z]
          else
            _sky(ray)
          end
        end)
      end)
    { :ok, py_exec } = :python.start( [ python_path: 'lib' ] )
    :python.call( py_exec, :image, :show, [img] )
    :python.stop( py_exec )
  end
  defp _sky(ray) do
    d = Vec3.normalize(ray.dir)
    t = 0.5 * (d.y + 1.0)

    _lerp(%Vec3{x: 127, y: 179, z: 255 }, %Vec3{x: 255, y: 255, z: 255}, t)
  end
  defp _lerp(s, e, perc) do
    vec3 = Vec3.add(s, Vec3.scale(Vec3.sub(e, s), perc))
    [vec3.x, vec3.y, vec3.z]
  end
end