defmodule LiveViewExample.Weather do

  def search_by(nil) do
    {:error, "location is obligatory"}
  end

  def search_by(location) do
    location = String.trim(location)

    with {:ok, url} <- get_endpoint(location),
         {:ok, resp} <- HTTPoison.get(url),
         {:ok, parsed_resp} <- parse_response(resp),
         do: {:ok, parsed_resp}
  end

  def get_appid() do
    System.get_env("OPEN_WEATHER_KEY")
  end

  def get_url() do
    "http://api.openweathermap.org/data/2.5/weather?q="
  end

  def get_endpoint(""), do: {:error, "location is obligatory"}
  def get_endpoint(nil), do: {:error, "location is obligatory"}

  def get_endpoint(location) do
    url = get_url()
    location = URI.encode(location)
    key = get_appid()

    case key do
      nil ->
        {:error, "API key not found"}

      key ->
        {:ok, "#{url}#{location}&appid=#{key}"}
    end
  end

  def kelvin_to_celsius(kelvin_temp) do
    temperature_zero_in_kelvin = 273.15

    {celsius, _} =
      (kelvin_temp - temperature_zero_in_kelvin)
      |> Float.to_string()
      |> Integer.parse()

    celsius
  end

  defp parse_response(%HTTPoison.Response{body: body, status_code: 200}) do
    data =
      body
      |> Jason.decode!()

    {:ok, data}
  end

  defp parse_response({:error, %HTTPoison.Error{}}) do
    {:error, "HTTPoison.Error"}
  end

  defp parse_response(%HTTPoison.Response{body: body, status_code: 404}) do
    {:error, "city not found"}
  end

end
