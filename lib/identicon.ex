defmodule Identicon do
  defstruct name: "", seed: nil, color: nil, colored_pixels: nil

  def generate(name) do
    %Identicon{name: name |> String.trim()}
    |> set_seed
    |> set_color
    |> set_colored_pixel_indexes
    |> generate_image

    IO.puts("Image successfully generated at location: output/#{name}.png")
  end

  defp set_seed(%Identicon{name: name} = identicon),
    do:
      Map.put(
        identicon,
        :seed,
        :crypto.hash(:sha512, name) |> :binary.bin_to_list() |> Enum.take(50)
      )

  defp set_color(%Identicon{seed: [r, g, b | _tl]} = identicon),
    do: Map.put(identicon, :color, ImageGenerator.create_color({r, g, b}))

  defp set_colored_pixel_indexes(%Identicon{seed: seed} = identicon),
    do: Map.put(identicon, :colored_pixels, get_colored_pixel_coords(seed))

  defp get_colored_pixel_coords(seed) do
    seed
    |> Stream.chunk_every(5)
    |> Enum.map(&[&1 | Enum.reverse(&1)])
    |> List.flatten()
    |> Stream.with_index()
    |> Enum.filter(&even?(elem(&1, 0)))
    |> Enum.map(&(elem(&1, 1) |> CoordGenerator.generate_coords()))
  end

  defp even?(num), do: rem(num, 2) == 0

  defp generate_image(%Identicon{name: name, color: color, colored_pixels: coords}) do
    image = ImageGenerator.create_base_img()
    Enum.each(coords, fn {p1, p2} -> ImageGenerator.draw_pixel(image, p1, p2, color) end)
    ImageGenerator.save_image(image, name)
  end
end

defmodule CoordGenerator do
  def generate_coords(pixel_number) do
    {x1, y1} = {get_col_number(pixel_number) * 50, get_row_number(pixel_number) * 50}
    {x2, y2} = {x1 + 50, y1 + 50}
    {{x1, y1}, {x2, y2}}
  end

  defp get_row_number(pixel_number), do: div(pixel_number, 10)
  defp get_col_number(pixel_number), do: rem(pixel_number, 10)
end

defmodule ImageGenerator do
  def create_base_img(width \\ 500, height \\ 500), do: :egd.create(width, height)
  def create_color({r, g, b} = rgb), do: :egd.color(rgb)
  def draw_pixel(image, p1, p2, color), do: :egd.filledRectangle(image, p1, p2, color)

  def save_image(image, name \\ "image"),
    do: image |> :egd.render(:png) |> :egd.save("output\\#{name}.png")
end
