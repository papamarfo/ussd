defmodule Ussd.Menu do
  @moduledoc false

  def text(menu, text), do: menu <> text

  def space(text, count \\ 1) do
    text <> String.duplicate("\n", count)
  end

  def list(menu, list) do
    list =
      list
      |> Enum.with_index(1)
      |> Enum.map_join("\n", fn {x, i} -> "#{i}. #{x}" end)

    menu <> list
  end

  def manual_list(menu, list) do
    menu <> Enum.join(list, "\n")
  end
end
