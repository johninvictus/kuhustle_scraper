defmodule KuhustleScraper.Kuhustle do
  use HTTPotion.Base

  require Logger

  @moduledoc """
  contact the kuhustle website
  """

  @base_url "https://www.kuhustle.com"
  @agent "elixir_webscraper"

  @doc """
  extending the client,
  """
  def process_url(path) do
    (@base_url <> path <> "/")
    |> URI.encode()
  end

  @doc """
  set all headers here
  """
  def process_request_headers(headers) do
    headers =
      Keyword.put(headers, :"User-Agent", @agent)
      |> Keyword.put(:"Content-Type", "text/html")

    headers
  end

  def process_response(%HTTPotion.Response{status_code: status_code, body: body} = resp) do
    cond do
      status_code == 200 ->
        {:ok, body, resp}

      true ->
        {:error, resp}
    end
  end

  def process_response(%HTTPotion.ErrorResponse{message: message}) do
    {:local_error, message}
  end
end
