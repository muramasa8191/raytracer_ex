defmodule RaytracerEx do
  @moduledoc """
  Documentation for RaytracerEx.
  """

  @doc """
  Hello world.
  ## Examples

      iex> RaytracerEx.hello()
      :world

  """
  def hello do
    :world
  end

  alias RaytracerEx.Vector.Vec3, as: Vec3
  alias RaytracerEx.Camera, as: Camera
  alias RaytracerEx.Sphere, as: Sphere
  alias RaytracerEx.Scene, as: Scene
  alias RaytracerEx.Ray, as: Ray
  alias RaytracerEx.Material.Lambertian, as: Lambertian
  alias RaytracerEx.Material.Metal, as: Metal
  alias RaytracerEx.Material.Dielectric, as: Dielectric

  def sphere_world(type \\ 0) do

    s = NaiveDateTime.utc_now()  
    nx = 200
    ny = 100
    lookfrom = Vec3.vec3([11.0, 2.0, 3.0])
    lookat = Vec3.vec3([0.0, 0.0, 0.0])
    dist_to_focus = Vec3.len(Vec3.sub(lookfrom, lookat))
    IO.puts("focus = #{dist_to_focus}")
    aperture = 0.1
    camera = Camera.create(lookfrom, lookat, Vec3.vec3([0.0, 1.0, 0.0]), 20.0, nx/ny, aperture, dist_to_focus)

    base = %Sphere{center: Vec3.vec3([0.0, -1000.0, 0.0]), r: 1000.0, material: %Lambertian{albedo: Vec3.vec3([0.5, 0.5, 0.5])}}
    ss= 
    for a <- -11..10, b <- -11..10 do
      choose_mat = :rand.uniform()
      center = Vec3.vec3([a + 0.9 * :rand.uniform(), 0.2, b + 0.9 * :rand.uniform()])
      if Vec3.len(Vec3.sub(center, Vec3.vec3([4.0, 0.2, 0.0]))) > 0.9 do
        if choose_mat < 0.8 do
          %Sphere{center: center, r: 0.2, 
                  material: %Lambertian{albedo: Vec3.vec3([:rand.uniform() * :rand.uniform(), :rand.uniform()*:rand.uniform(), :rand.uniform()*:rand.uniform()])}}
        else
          if choose_mat < 0.95 do
            %Sphere{center: center, r: 0.2,
                    material: %Metal{albedo: Vec3.vec3([0.5 * (1 + :rand.uniform()), 0.5 * (1 + :rand.uniform()), 0.5 * (1 + :rand.uniform())]), fuzz: 0.5 * :rand.uniform()}}
          else
            %Sphere{center: center, r: 0.2, material: %Dielectric{ri: 1.5}}
          end
        end
      end
    end
    |> Enum.filter(&(not is_nil(&1)))
    objects = [base]++ss
    objects = [%Sphere{center: Vec3.vec3([0.0, 1.0, 0.0]), r: 1.0, material: %Dielectric{ri: 1.5}}]++objects
    objects = [%Sphere{center: Vec3.vec3([-4.0, 1.0, 0.0]), r: 1.0, material: %Lambertian{albedo: Vec3.vec3([0.4, 0.2, 0.1])}}]++objects
    objects = [%Sphere{center: Vec3.vec3([4.0, 1.0, 0.0]), r: 1.0, material: %Metal{albedo: Vec3.vec3([0.7, 0.6, 0.5]), fuzz: 0.0}}]++objects

    scene = Scene.create_scene(nx, ny, camera, objects)
    e = 
    if type == 0 do
      Scene.render(scene)
    else
      Scene.single_render(scene)
    end
    IO.puts("render :#{NaiveDateTime.diff(e, s, :millisecond)} msec")

  end

  def camera_test2() do
    nx = 400
    ny = 200
    lookfrom = Vec3.vec3([3.0, 3.0, 2.0])
    lookat = Vec3.vec3([0.0, 0.0, -1.0])
    dist_to_focus = Vec3.len(Vec3.sub(lookfrom, lookat))
    aperture = 2.0
    camera = Camera.create(lookfrom, lookat, Vec3.vec3([0.0, 1.0, 0.0]), 20.0, nx/ny, aperture, dist_to_focus)

    sphere = %Sphere{center: %Vec3{x: 0.0, y: 0.0, z: -1.0}, r: 0.5, material: %Lambertian{albedo: Vec3.vec3([0.8, 0.3, 0.3])}}    
    sphere2 = %Sphere{center: %Vec3{x: 0.0, y: -100.5, z: -1.0}, r: 100, material: %Lambertian{albedo: Vec3.vec3([0.8, 0.8, 0.0])}}    
    sphere3 = %Sphere{center: %Vec3{x: 1.0, y: 0.0, z: -1.0}, r: 0.5, material: %Metal{albedo: Vec3.vec3([0.8, 0.6, 0.2])}}   
    sphere4 = %Sphere{center: %Vec3{x: -1.0, y: 0.0, z: -1.0}, r: 0.5, material: %Dielectric{ri: 1.5}}
    sphere5 = %Sphere{center: %Vec3{x: -1.0, y: 0.0, z: -1.0}, r: -0.45, material: %Dielectric{ri: 1.5}}
    scene = Scene.create_scene(nx, ny, camera, [sphere, sphere2, sphere3, sphere4, sphere5])

    Scene.render(scene)
  end
  def camera_test() do
    nx = 200
    ny = 100
    lookfrom = Vec3.vec3([-2.0, 2.0, 1.0])
    lookat = Vec3.vec3([0.0, 0.0, -1.0])
    dist_to_focus = Vec3.len(Vec3.sub(lookfrom, lookat))
    camera = Camera.create(lookfrom, lookat, Vec3.vec3([0.0, 1.0, 0.0]), 90.0, nx/ny, 0.0, dist_to_focus)

    sphere = %Sphere{center: %Vec3{x: 0.0, y: 0.0, z: -1.0}, r: 0.5, material: %Lambertian{albedo: Vec3.vec3([0.8, 0.3, 0.3])}}    
    sphere2 = %Sphere{center: %Vec3{x: 0.0, y: -100.5, z: -1.0}, r: 100, material: %Lambertian{albedo: Vec3.vec3([0.8, 0.8, 0.0])}}    
    sphere3 = %Sphere{center: %Vec3{x: 1.0, y: 0.0, z: -1.0}, r: 0.5, material: %Metal{albedo: Vec3.vec3([0.8, 0.6, 0.2])}}   
    sphere4 = %Sphere{center: %Vec3{x: -1.0, y: 0.0, z: -1.0}, r: 0.5, material: %Dielectric{ri: 1.5}}
    sphere5 = %Sphere{center: %Vec3{x: -1.0, y: 0.0, z: -1.0}, r: -0.45, material: %Dielectric{ri: 1.5}}
    scene = Scene.create_scene(nx, ny, camera, [sphere, sphere2, sphere3, sphere4, sphere5])

    Scene.render(scene)
  end
  def material_test() do
    nx = 200
    ny = 100
    lookfrom = Vec3.vec3([-1.0, 0.0, 1.0])
    lookat = Vec3.vec3([0.0, 0.0, -1.0])
    dist_to_focus = Vec3.len(Vec3.sub(lookfrom, lookat))
    camera = Camera.create(lookfrom, lookat, Vec3.vec3([0.0, 1.0, 0.0]), 90.0, nx/ny, 0.0, dist_to_focus)
    sphere = %Sphere{center: %Vec3{x: 0.0, y: 0.0, z: -1.0}, r: 0.5, material: %Lambertian{albedo: Vec3.vec3([0.8, 0.3, 0.3])}}    
    sphere2 = %Sphere{center: %Vec3{x: 0.0, y: -100.5, z: -1.0}, r: 100, material: %Lambertian{albedo: Vec3.vec3([0.8, 0.8, 0.0])}}    
    sphere3 = %Sphere{center: %Vec3{x: 1.0, y: 0.0, z: -1.0}, r: 0.5, material: %Metal{albedo: Vec3.vec3([0.8, 0.6, 0.2])}}   
    sphere4 = %Sphere{center: %Vec3{x: -1.0, y: 0.0, z: -1.0}, r: 0.5, material: %Dielectric{ri: 1.5}}
    sphere5 = %Sphere{center: %Vec3{x: -1.0, y: 0.0, z: -1.0}, r: -0.45, material: %Dielectric{ri: 1.5}}
    scene = Scene.create_scene(nx, ny, camera, [sphere, sphere2, sphere3, sphere4, sphere5])

    Scene.render(scene)
  end
  def scene_test2() do
    nx = 400
    ny = 200
    u = %Vec3{x: 4.0, y: 0.0, z: 0.0 }
    v = %Vec3{x: 0.0, y: 2.0, z: 0.0 }
    w = %Vec3{x: -2.0, y: -1.0, z: -1.0 }
    camera = %Camera{u: u, v: v, w: w}
    sphere = %Sphere{center: %Vec3{x: 0.0, y: 0.0, z: -1.0}, r: 0.5}    
    sphere2 = %Sphere{center: %Vec3{x: 0.0, y: -100.5, z: -1.0}, r: 100}    
    scene = Scene.create_scene(nx, ny, camera, [sphere, sphere2])

    Scene.render(scene)
  end
  def scene_test() do
    nx = 200
    ny = 100
    u = %Vec3{x: 4.0, y: 0.0, z: 0.0 }
    v = %Vec3{x: 0.0, y: 2.0, z: 0.0 }
    w = %Vec3{x: -2.0, y: -1.0, z: -1.0 }
    camera = %Camera{u: u, v: v, w: w}
    sphere = %Sphere{center: %Vec3{x: 0.0, y: 0.0, z: -1.0}, r: 0.5}    
    scene = Scene.create_scene(nx, ny, camera, [sphere])

    Scene.render(scene)
  end
  def sphere_shadow_test() do
    nx = 400
    ny = 200
    u = %Vec3{x: 4.0, y: 0.0, z: 0.0 }
    v = %Vec3{x: 0.0, y: 2.0, z: 0.0 }
    w = %Vec3{x: -2.0, y: -1.0, z: -1.0 }
    camera = %Camera{u: u, v: v, w: w}
    sphere = %Sphere{center: %Vec3{x: 0.0, y: 0.0, z: -1.0}, r: 0.5}
    img = _sphere_shadow_test(ny - 1, nx, ny, camera, sphere, [])
    show(img)
  end
  defp _sphere_shadow_test(-1, _nx, _ny, _camera, _shpere, arr) do
    Enum.reverse(arr)
  end
  # defp _sphere_shadow_test(y, nx, ny, camera, sphere, arr) do
  #   {_, res} =
  #   List.duplicate([], nx)
  #   |> Enum.reduce({nx-1, []}, 
  #     fn _x, {idx, arr} -> 
  #       u = idx / nx
  #       v = y / ny
  #       ray = Camera.get_ray(camera, u, v)
  #       h = Sphere.hit(sphere, ray)
  #       if h > 0.0 do
  #         norm = Vec3.unit_vector(Vec3.sub(Ray.at(ray, h), sphere.center))
  #         color = Vec3.scale(Vec3.add(norm, %Vec3{x: 1.0, y: 1.0, z: 1.0}), 127.5)
  #         {idx-1, [[color.x, color.y, color.z]] ++ arr}
  #       else
  #         {idx-1, [_gradation(ray)] ++ arr}
  #       end
  #     end)
  #   _sphere_shadow_test(y-1, nx, ny, camera, sphere, [res] ++ arr)
  # end


  defp _lerp(s, e, perc) do
    vec3 = Vec3.add(s, Vec3.scale(Vec3.sub(e, s), perc))
    [vec3.x, vec3.y, vec3.z]
  end
  def show(arr) do
    { :ok, py_exec } = :python.start( [ python_path: 'lib' ] )
    :python.call( py_exec, :image, :show, [arr] )
    :python.stop( py_exec )
  end

  def gradation() do
    nx = 200
    ny = 100
    for y <- ny-1..0 do
      for x <- 0..nx-1 do
        [x / nx, y / ny, 0.2]
        |> Enum.map(&(255 * &1))
      end
    end
  end
  def sky() do
    nx = 200
    ny = 100
    low_left = Vec3.vec3([-2.0, -1.0, -1.0])
    horizontal = Vec3.vec3([4.0, 0.0, 0.0])
    vertical = Vec3.vec3([0.0, 2.0, 0.0])
    origin = Vec3.vec3([0.0, 0.0, 0.0])
    for y <- ny-1..0 do
      for x <- 0..nx-1 do
        u = x / nx
        v = y / ny
        ray = %Ray{pos: origin, 
                   dir: Vec3.scale(horizontal, u) 
                        |> Vec3.add(Vec3.scale(vertical, v)) 
                        |> Vec3.add(low_left)
              }
        unit_vec = Vec3.unit_vector(ray.dir)
        t = 0.5 * (unit_vec.y + 1.0)
        color = Vec3.scale(Vec3.ones(), (1.0 - t))
                |> Vec3.add(Vec3.scale(Vec3.vec3([0.5, 0.7, 1.0]), t))
        [color.x, color.y, color.z] |> Enum.map(&(&1 * 255))
      end
    end
    |> show
  end

  def hit_sphere(center, radius, ray) do
    oc = Vec3.sub(ray.pos, center)
    a = Vec3.dot(ray.dir, ray.dir)
    b = Vec3.dot(oc, ray.dir) * 2.0
    c = Vec3.dot(oc, oc) - radius * radius
    discriminant = b * b - 4 * a * c
    discriminant > 0.0
  end
  def sphere_color(ray) do
    if hit_sphere(Vec3.vec3([0.0, 0.0, -1.0]), 0.5, ray) do
      Vec3.vec3([1.0, 0.0, 0.0])
    else
      unit_vec = Vec3.unit_vector(ray.dir)
      t = 0.5 * (unit_vec.y + 1.0)
      Vec3.scale(Vec3.ones(), (1.0 - t))
          |> Vec3.add(Vec3.scale(Vec3.vec3([0.5, 0.7, 1.0]), t))
    end
  end
  def draw_sphere() do
    nx = 200
    ny = 100
    low_left = Vec3.vec3([-2.0, -1.0, -1.0])
    horizontal = Vec3.vec3([4.0, 0.0, 0.0])
    vertical = Vec3.vec3([0.0, 2.0, 0.0])
    origin = Vec3.vec3([0.0, 0.0, 0.0])
    for y <- ny-1..0 do
      for x <- 0..nx-1 do
        u = x / nx
        v = y / ny
        ray = %Ray{pos: origin, 
                   dir: Vec3.scale(horizontal, u) 
                        |> Vec3.add(Vec3.scale(vertical, v)) 
                        |> Vec3.add(low_left)
              }
        color = sphere_color(ray)
        [color.x, color.y, color.z] |> Enum.map(&(&1 * 255))
      end
    end
    |> show
  end

  defp _sky(ray) do
    unit_vec = Vec3.unit_vector(ray.dir)
    t = 0.5 * (unit_vec.y + 1.0)
    Vec3.scale(Vec3.ones(), (1.0 - t))
        |> Vec3.add(Vec3.scale(Vec3.vec3([0.5, 0.7, 1.0]), t))
  end

  def antialias() do
    nx = 200
    ny = 100
    ns = 100
    low_left = Vec3.vec3([-2.0, -1.0, -1.0])
    horizontal = Vec3.vec3([4.0, 0.0, 0.0])
    vertical = Vec3.vec3([0.0, 2.0, 0.0])
    origin = Vec3.vec3([0.0, 0.0, 0.0])
    objects = [%Sphere{center: Vec3.vec3([0.0, 0.0, -1.0]), r: 0.5},
               %Sphere{center: Vec3.vec3([0.0, -100.5, -1.0]), r: 100.0}]
    for y <- ny-1..0 do
      for x <- 0..nx-1 do
        color = 
        for s <- 1..ns do
          u = (x + :rand.uniform()) / nx
          v = (y + :rand.uniform()) / ny
          ray = %Ray{pos: origin, 
                  dir: Vec3.scale(horizontal, u) 
                        |> Vec3.add(Vec3.scale(vertical, v)) 
                        |> Vec3.add(low_left)
              }
          _color(ray, objects)
        end
        |> Enum.reduce(%Vec3{}, fn c, color -> Vec3.add(color, c) end)
        |> Vec3.div(ns)
        [color.x, color.y, color.z]
        |> Enum.map(&(:math.sqrt(&1) * 255)) 
      end
    end
    |> show
  end

  defp _random_in_unit_shpere() do
    p = Vec3.vec3([:rand.uniform(), :rand.uniform(), :rand.uniform()])
        |> Vec3.scale(2.0)
        |> Vec3.sub(Vec3.ones())
    if Vec3.lengthSqr(p) < 1.0, do: p, else: _random_in_unit_shpere()
  end
  defp _color(ray, objects) do
    obj_arr = _hit(objects, ray, 0.001, 999999)
    if obj_arr != [] do 
      obj = hd obj_arr
      target = Vec3.add(obj.pos, obj.normal) |> Vec3.add(_random_in_unit_shpere())
      _color(%Ray{pos: obj.pos, dir: Vec3.sub(target, obj.pos)}, objects) |> Vec3.scale(0.5)
    else
      _sky(ray)
    end
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
