defmodule KuhustleScraper.Scrapper do
  def get(body) do
    body
    |> Floki.parse()
    |> Floki.find(".project-item")
    |> Enum.map(&map_data/1)
  end

  defp map_data({"div", _attr, content}) do
    title = content |> get_title
    description = content |> get_description()
    price_quote = content |> get_quote()
    binds = content |> get_binds()
    featured = content |> is_featured()

    %{
      title: title,
      description: description,
      featured: featured,
      price: price_quote,
      binds: binds
    }
  end

  defp get_title(content) do
    [{"a", _attrs, [title]}] =
      content
      |> Floki.find("h4.project-heading > a")

    title
  end

  defp get_description(content) do
    data = content |> Floki.find("p.project-description")

    case data do
      [{"p", _attr, [content]}] ->
        content |> String.trim()

      [{"p", _attr, [content, {_br, [], []}]}] ->
        content |> String.trim()
    end
  end

  defp get_quote(content) do
    [{"strong", [], [quote]}] =
      content
      |> Floki.find("table.table tbody tr td.price strong")

    quote
  end

  defp get_binds(content) do
    [{"td", _attr, [binds]}] =
      content
      |> Floki.find("table.table tbody tr td.text-center")

    binds |> String.trim()
  end

  def is_featured(content) do
    data =
      content
      |> Floki.find("span.label-featured")

    case data do
      [{"span", _attr, ["Featured"]}] ->
        true

      _ ->
        false
    end
  end
end
