defmodule RaytracerEx.Scene do
  alias __MODULE__, as: Scene
  alias RaytracerEx.Vector.Vec3, as: Vec3
  alias RaytracerEx.Ray, as: Ray
  alias RaytracerEx.Sphere, as: Sphere
  alias RaytracerEx.Camera, as: Camera
  
  defstruct nx: 200, ny: 100, ns: 100, camera: %Camera{}, objects: []

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
    s = NaiveDateTime.utc_now()  
    img =
    scene.ny-1..0
    |> Enum.to_list
    |> Flow.from_enumerable(max_demand: 2)
    |> Flow.map(fn y->
      row = 
      0..scene.nx-1
        |> Enum.map(fn x ->
          color =
          1..scene.ns
          |> Enum.reduce(%Vec3{}, fn (_x, c) ->
            u = (x + :rand.uniform()) / scene.nx
            v = (y + :rand.uniform()) / scene.ny
            ray = Camera.get_ray(scene.camera, u, v)
            Vec3.add(c, _color(ray, scene.objects))
          end)
          Vec3.to_list(Vec3.div(color, scene.ns)) |> Enum.map(&(:math.sqrt(&1) * 255))
        end)
      {y, row}
      end)
    |> Enum.sort(&(elem(&1, 0) > elem(&2, 0)))
    |> Enum.map(&elem(&1, 1))
    { :ok, py_exec } = :python.start( [ python_path: 'lib' ] )
    :python.call( py_exec, :image, :show, [img] )
    :python.stop( py_exec )

    e = NaiveDateTime.utc_now()
    IO.puts("render :#{NaiveDateTime.diff(e, s, :millisecond)} msec")
  end
  defp _color(ray, objects) do
    hit = _hit(objects, ray, 0.0001, 99999)
    if hit != [] do
      obj = hd hit
      target = Vec3.add(Vec3.add(obj.pos, obj.normal), Ray.random_in_unit_sphere())
      Vec3.scale(_color(%Ray{pos: obj.pos, dir: Vec3.sub(target, obj.pos)}, objects), 0.5)
    else
      _sky(ray)
    end
  end
  defp _sky(ray) do
    d = Vec3.normalize(ray.dir)
    t = 0.5 * (d.y + 1.0)

    _lerp(%Vec3{x: 0.5, y: 0.7, z: 1.0 }, %Vec3{x: 1.0, y: 1.0, z: 1.0}, t)
  end
  defp _lerp(s, e, perc) do
    Vec3.add(Vec3.scale(s, perc), Vec3.scale(e, 1.0 - perc))
  end
  defp _hit(objects, ray, t_min, t_max) do
    objects
    |> Enum.map(fn obj ->
      case obj.type do
        :sphere -> Sphere.hit(obj, ray, t_min, t_max)
      end
    end)
    |> Enum.filter(&(elem(&1, 0)))
    |> Enum.sort(&(elem(&1, 1).t < elem(&2, 1).t))
    |> Enum.take(1)
    |> Enum.map(&(elem(&1, 1)))
  end
end