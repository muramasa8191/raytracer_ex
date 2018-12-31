defmodule RaytracerEx.Vector do
  defmodule Vec3 do
    defstruct x: 0.0, y: 0.0, z: 0.0
    alias RaytracerEx.Vector.Vec3, as: Vec3
    def vec3(list) when is_list(list) do
      [x | rest] = list
      [y | [z]] = rest
      %Vec3{x: x, y: y, z: z}
    end
    def ones() do
      %Vec3{x: 1.0, y: 1.0, z: 1.0}
    end
    def add(vec1, vec2) do
      %Vec3{x: vec1.x + vec2.x, y: vec1.y + vec2.y, z: vec1.z + vec2.z }
    end
    def dot(vec1, vec2) do
      vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z
    end
    def mult(vec1, vec2) do
      %Vec3{x: vec1.x * vec2.x, y: vec1.y * vec2.y, z: vec1.z * vec2.z }
    end
    def scale(vec, s) do
      %Vec3{x: vec.x * s, y: vec.y * s, z: vec.z * s }
    end
    def sub(vec1, vec2) when is_map vec2 do
      %Vec3{x: vec1.x - vec2.x, y: vec1.y - vec2.y, z: vec1.z - vec2.z }
    end
    def sub(vec, s) do
      %Vec3{x: vec.x - s, y: vec.y - s, z: vec.z - s}
    end
    def len(vec) do
      :math.sqrt(lengthSqr(vec))
    end
    def lengthSqr(vec) do
      vec.x * vec.x + vec.y * vec.y + vec.z * vec.z
    end
    def div(vec, scalar) do
      %Vec3{x: vec.x / scalar, y: vec.y / scalar, z: vec.z / scalar}
    end
    def unit_vector(vec) do
      s = len(vec)
      Vec3.div(vec, s)
    end
    def cross(vec1, vec2) do
      x = vec1.y * vec2.z - vec1.z * vec2.y
      y = vec1.z * vec2.x - vec1.x * vec2.z
      z = vec1.x * vec2.y - vec1.y * vec2.x
      %Vec3{x: x, y: y, z: z}
    end
    def to_list(vec3) do
      [vec3.x, vec3.y, vec3.z]
    end
    def reflect(vec, normal) do
      Vec3.sub(vec, Vec3.mult(Vec3.scale(Vec3.dot(vec, normal), 2.0), normal))
    end
    def refract(vec, normal, ni_over_nt) do
      uv = Vec3.unit_vector(vec)
      dt = Vec3.dot(uv, normal)
      discriminant = 1.0 - ni_over_nt * ni_over_nt * (1.0 - dt * dt)
      if (discriminant > 0.0) do
        refracted = Vec3.sub(Vec3.scale(Vec3.sub(uv, Vec3.scale(normal, dt)), ni_over_nt), Vec3.scale(normal, :math.sqrt(discriminant)))
        {true, refracted}
      else
        {false, nil}
      end
    end
  end
end