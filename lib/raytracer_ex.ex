defmodule RaytracerEx do
  @moduledoc """
  Documentation for RaytracerEx.
  """

  @doc """
  Hello world.
  https://qiita.com/mebiusbox2/items/89e2db3b24e4c39502fe
  ## Examples

      iex> RaytracerEx.hello()
      :world

  """
  def hello do
    :world
  end

  alias RaytracerEx.Vector.Vec3, as: Vec3
  alias RaytracerEx.Ray, as: Ray
  alias RaytracerEx.Camera, as: Camera
  alias RaytracerEx.Sphere, as: Sphere
  alias RaytracerEx.Scene, as: Scene
  alias RaytracerEx.Material.Lambertian, as: Lambertian
  alias RaytracerEx.Material.Metal, as: Metal
  alias RaytracerEx.Material.Dielectric, as: Dielectric
  def test(w, h) do
    _test(h, w, h, [])
  end
  def _test(0, _width, _height, arr) do
    {0, arr}
  end
  def _test(y, width, height, arr) do
    {_, array} = 
    List.duplicate([], width)
    |> Enum.reduce({0, []}, fn (_x, {idx, arr}) -> {idx + 1, [[idx / width * 255, y / height * 255, 127]]++arr} end)

    _test(y - 1, width, height, [Enum.reverse(array)]++arr)
  end
  def show_color(w, h, r, g, b) do
    arr = List.duplicate(List.duplicate([r, g, b], w), h)

    { :ok, py_exec } = :python.start( [ python_path: 'lib' ] )
    :python.call( py_exec, :image, :show, [arr] )
    :python.stop( py_exec )
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
    nx = 400
    ny = 200
    camera = Camera.create(Vec3.vec3([-2.0, 2.0, 1.0]), Vec3.vec3([0.0, 0.0, -1.0]), Vec3.vec3([0.0, 1.0, 0.0]), 90.0, nx/ny)

    sphere = %Sphere{center: %Vec3{x: 0.0, y: 0.0, z: -1.0}, r: 0.5, material: %Lambertian{albedo: Vec3.vec3([0.8, 0.3, 0.3])}}    
    sphere2 = %Sphere{center: %Vec3{x: 0.0, y: -100.5, z: -1.0}, r: 100, material: %Lambertian{albedo: Vec3.vec3([0.8, 0.8, 0.0])}}    
    sphere3 = %Sphere{center: %Vec3{x: 1.0, y: 0.0, z: -1.0}, r: 0.5, material: %Metal{albedo: Vec3.vec3([0.8, 0.6, 0.2])}}   
    sphere4 = %Sphere{center: %Vec3{x: -1.0, y: 0.0, z: -1.0}, r: 0.5, material: %Dielectric{ri: 1.5}}
    sphere5 = %Sphere{center: %Vec3{x: -1.0, y: 0.0, z: -1.0}, r: -0.45, material: %Dielectric{ri: 1.5}}
    scene = Scene.create_scene(nx, ny, camera, [sphere, sphere2, sphere3, sphere4, sphere5])

    Scene.render(scene)
  end
  def material_test() do
    nx = 400
    ny = 200
    u = %Vec3{x: 4.0, y: 0.0, z: 0.0 }
    v = %Vec3{x: 0.0, y: 2.0, z: 0.0 }
    w = %Vec3{x: -2.0, y: -1.0, z: -1.0 }
    camera = %Camera{u: u, v: v, w: w}
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
  defp _sphere_shadow_test(y, nx, ny, camera, sphere, arr) do
    {_, res} =
    List.duplicate([], nx)
    |> Enum.reduce({nx-1, []}, 
      fn _x, {idx, arr} -> 
        u = idx / nx
        v = y / ny
        ray = Camera.get_ray(camera, u, v)
        h = Sphere.hit(sphere, ray)
        if h > 0.0 do
          norm = Vec3.normalize(Vec3.sub(Ray.at(ray, h), sphere.center))
          color = Vec3.scale(Vec3.add(norm, %Vec3{x: 1.0, y: 1.0, z: 1.0}), 127.5)
          {idx-1, [[color.x, color.y, color.z]] ++ arr}
        else
          {idx-1, [_gradation(ray)] ++ arr}
        end
      end)
    _sphere_shadow_test(y-1, nx, ny, camera, sphere, [res] ++ arr)
  end

  def sphere_test() do
    nx = 200
    ny = 100
    u = %Vec3{x: 4.0, y: 0.0, z: 0.0 }
    v = %Vec3{x: 0.0, y: 2.0, z: 0.0 }
    w = %Vec3{x: -2.0, y: -1.0, z: -1.0 }
    camera = %Camera{u: u, v: v, w: w}
    sphere = %Sphere{center: %Vec3{x: 0.0, y: 0.0, z: -1.0}, r: 0.5}
    img = _sphere_loop(ny - 1, nx, ny, camera, sphere, [])
    show(img)
  end
  defp _sphere_loop(-1, _nx, _ny, _camera, _shpere, arr) do
    arr
  end
  defp _sphere_loop(y, nx, ny, camera, sphere, arr) do
    {_, res} =
    List.duplicate([], nx)
    |> Enum.reduce({nx-1, []}, 
      fn _x, {idx, arr} -> 
        u = idx / nx
        v = y / ny
        ray = Camera.get_ray(camera, u, v)
        color = if Sphere.is_hit(sphere, ray), do: [255, 0, 0], else: _gradation(ray) 
        {idx-1, [color] ++ arr} end)
    _sphere_loop(y-1, nx, ny, camera, sphere, [res] ++ arr)
  end
  def gradation() do
    nx = 200
    ny = 100
    u = %Vec3{x: 4.0, y: 0.0, z: 0.0 }
    v = %Vec3{x: 0.0, y: 2.0, z: 0.0 }
    w = %Vec3{x: -2.0, y: -1.0, z: -1.0 }
    camera = %Camera{u: u, v: v, w: w}

    img = _grad_loop(ny-1, nx, ny, camera, [])
    show(img)
  end
  defp _grad_loop(-1, _nx, _ny, _camera, arr) do
    arr
  end
  defp _grad_loop(y, nx, ny, camera, arr) do
    {_, res} =
    List.duplicate([], nx)
    |> Enum.reduce({nx-1, []}, 
      fn _x, {idx, arr} -> 
        u = idx / nx
        v = y / ny
        ray = Camera.get_ray(camera, u, v)
        {idx-1, [_gradation(ray)] ++ arr} end)
    _grad_loop(y-1, nx, ny, camera, [res] ++ arr)
  end
  defp _gradation(ray) do
    d = Vec3.normalize(ray.dir)
    t = 0.5 * (d.y + 1.0)

    _lerp(%Vec3{x: 127, y: 179, z: 255 }, %Vec3{x: 255, y: 255, z: 255}, t)
  end
  defp _lerp(s, e, perc) do
    vec3 = Vec3.add(s, Vec3.scale(Vec3.sub(e, s), perc))
    [vec3.x, vec3.y, vec3.z]
  end
  def show(arr) do
    { :ok, py_exec } = :python.start( [ python_path: 'lib' ] )
    :python.call( py_exec, :image, :show, [arr] )
    :python.stop( py_exec )
  end
end
