defmodule RaytracerEx.Scene do
  alias __MODULE__, as: Scene
  alias RaytracerEx.Vector.Vec3, as: Vec3
  alias RaytracerEx.Ray, as: Ray
  alias RaytracerEx.Sphere, as: Sphere
  alias RaytracerEx.Camera, as: Camera
  alias RaytracerEx.Material, as: Material
  
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
    IO.puts("rendering start: nx=#{scene.nx}, ny=#{scene.ny}, ns=#{scene.ns}")
    img =
    scene.ny-1..0
    |> Enum.to_list
    |> Flow.from_enumerable(max_demand: 4)
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
            Vec3.add(c, _color(ray, scene.objects, 0))
          end)
          Vec3.to_list(Vec3.div(color, scene.ns)) |> Enum.map(&(:math.sqrt(&1) * 255))
        end)
      IO.puts("#{scene.ny - y} / #{scene.ny}")
      {y, row}
      end)
    |> Enum.sort(&(elem(&1, 0) > elem(&2, 0)))
    |> Enum.map(&elem(&1, 1))
    { :ok, py_exec } = :python.start( [ python_path: 'lib' ] )
    :python.call( py_exec, :image, :show, [img] )
    :python.stop( py_exec )
  end

  def single_render(scene) do
    IO.puts("rendering start: nx=#{scene.nx}, ny=#{scene.ny}, ns=#{scene.ns}")
    img =
    for y <- scene.ny-1..0 do
      row =
      for x <- 0..scene.nx-1 do
        color =
        1..scene.ns
        |> Enum.reduce(%Vec3{}, fn (_x, c) ->
          u = (x + :rand.uniform()) / scene.nx
          v = (y + :rand.uniform()) / scene.ny
          ray = Camera.get_ray(scene.camera, u, v)
          Vec3.add(c, _color(ray, scene.objects, 0))
        end)
        Vec3.to_list(Vec3.div(color, scene.ns)) |> Enum.map(&(:math.sqrt(&1) * 255))
      end
      IO.puts("#{scene.ny - y} / #{scene.ny} done")
      row
    end
    { :ok, py_exec } = :python.start( [ python_path: 'lib' ] )
    :python.call( py_exec, :image, :show, [img] )
    :python.stop( py_exec )
  end
  # defp _color(ray, objects) do
  #   hit = _hit(objects, ray, 0.0001, 99999)
  #   if hit != [] do
  #     obj = hd hit
  #     target = Vec3.add(Vec3.add(obj.pos, obj.normal), Ray.random_in_unit_sphere())
  #     Vec3.scale(_color(%Ray{pos: obj.pos, dir: Vec3.sub(target, obj.pos)}, objects), 0.5)
  #   else
  #     _sky(ray)
  #   end
  # end
  defp _color(ray, objects, depth) do
    hitrec = _hit(objects, ray, 0.001, 99999)
    if not is_nil(hitrec) do
      {sca, scattered, attenuation} = Material.scatter(hitrec.material, ray, hitrec)
      if sca and depth < 50 do
        Vec3.mult(attenuation, _color(scattered, objects, depth+1))
      else
        %Vec3{}
      end
    else
      _sky(ray)
    end
  end
  defp _sky(ray) do
    d = Vec3.unit_vector(ray.dir)
    t = 0.5 * (d.y + 1.0)

    _lerp(%Vec3{x: 0.5, y: 0.7, z: 1.0 }, %Vec3{x: 1.0, y: 1.0, z: 1.0}, t)
  end
  defp _lerp(s, e, perc) do
    Vec3.add(Vec3.scale(s, perc), Vec3.scale(e, 1.0 - perc))
  end
  defp _hit(objects, ray, t_min, t_max) do
    objects
    |> Enum.reduce(nil, fn obj, hitrec ->
      case obj.type do
        sphere ->
          tm = if not is_nil(hitrec), do: hitrec.t, else: t_max
          {is_hit, rec} =  Sphere.hit(obj, ray, t_min, tm)
          if is_hit and t_min < rec.t and rec.t < tm do
            rec
          else
            hitrec
          end
      end
    end)
  end
end