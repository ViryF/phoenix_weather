defmodule LiveViewExampleWeb.WeatherLive do
  use LiveViewExampleWeb, :live_view

  alias LiveViewExample.Weather

  @impl true
  def mount(_params, _session, socket) do
    params = %{
      location: empty_location(),
      loading: false,
      page_title: "OpenWeather"
    }

    socket = assign(socket, params)

    {:ok, socket}
  end


  @impl true
  def render(assigns) do
    ~L"""
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
      <title>OpenWeather Station</title>
      <h1>OpenWeather Station</h1>
      <h2>
        <img src="<%= Routes.static_path(@socket, "/images/phoenix-logo.svg") %>" alt="Phoenix Framework Logo"/>
      </h2>

      <form class="example" phx-submit="get-temperature">
        <input type="text"
               name="location"
               placeholder="location"
               autofocus
               autocomplete="off"
               <%= if @loading, do: "readonly" %> />

        <button type="submit"><i class="fa fa-search"></i></button>
      </form>

      <%= if @loading do %>
    	 <div class="wrapper">
    		 <i class="fa fa-refresh fa-spin"></i> Fetching
    	  </div>
      <% end %>

      <%= if @location[:name] do %>
        <div class="wrapper">
          <div class=grid-container-weather>
            <div class="grid-item icon"><img src="<%= @location.weather_icon %>" alt="weather icon"/></div>
            <div class="grid-item icon_text"><%= @location.weather_icon_text %></div>
            <div class="grid-item temperature"><%= @location.temperature %> &#8451;</div>
            <div class="grid-item location"><%= @location.name %></div>
          </div>
          </div>
        </div>
      <% end %>
    """
  end

  def handle_event("get-temperature", %{"location" => location}, socket) do
    send(self(), {:run_get_temp, location})

    socket =
      socket
      |> assign(:loading, true)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:run_get_temp, location}, socket) do
    case Weather.search_by(location) do
      {:ok, data} ->
        location = parse(data)

        socket =
          socket
          |> clear()
          |> assign(:location, location)

        {:noreply, socket}

      {:error, err} ->
        socket =
          socket
          |> clear()
          |> put_flash(:info, "No location matches \"#{location}\" - #{err}")

        {:noreply, socket}
    end
  end

  defp empty_location do
    %{
      weather_icon: nil,
      weather_icon_text: nil,
      temperature: nil,
      name: nil
    }
  end

  defp clear(socket) do
    socket
    |> clear_flash()
    |> assign(:loading, false)
    |> assign(:location, empty_location())
  end

  defp parse(data) do
    location = empty_location()
    weather = List.first(data["weather"])
    icon = get_icon( weather["icon"] )

    location =
      location
      |> Map.put(:weather_icon, icon)
      |> Map.put(:weather_icon_text, weather["main"])
      |> Map.put(:weather_description, weather["description"])
      |> Map.put(:temperature, Weather.kelvin_to_celsius(data["main"]["temp"]))
      |> Map.put(:name, data["name"])
  end

  defp get_icon(code) do
    "http://openweathermap.org/img/wn/#{code}@2x.png"
  end
end
