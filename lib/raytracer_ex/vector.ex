defmodule RaytracerEx.Vector do
  defmodule Vec3 do
    alias RaytracerEx.Vector.Vec3, as: Vec3
    defstruct x: 0.0, y: 0.0, z: 0.0
    def add(vec1, vec2) do
      %Vec3{x: vec1.x + vec2.x, y: vec1.y + vec2.y, z: vec1.z + vec2.z }
    end
    def dot(vec1, vec2) do
      vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z
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
      :math.sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z)
    end
    def normalize(vec) do
      s = len(vec)
      scale(vec, 1 / s)
    end
    def cross(vec1, vec2) do
      x = vec1.y * vec2.z - vec1.z * vec2.y
      y = vec1.z * vec2.x - vec1.x * vec2.z
      z = vec1.x * vec2.y - vec1.y * vec2.x
      %Vec3{x: x, y: y, z: z}
    end
  end
  defmodule Vec4 do
    defstruct x: 0.0, y: 0.0, z: 0.0, w: 0.0
  end
end