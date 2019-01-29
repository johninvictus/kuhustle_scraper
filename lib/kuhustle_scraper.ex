defmodule KuhustleScraper do
  @moduledoc """
  Documentation for KuhustleScraper.
  """

  alias KuhustleScraper.Kuhustle
  alias KuhustleScraper.Scrapper

  def get_jobs do
    response =
      Kuhustle.get("/jobs")
      |> Kuhustle.process_response()

    case response do
      {:ok, body, _resp} ->
        Scrapper.get(body)

      _ ->
        :error
    end
  end
end
