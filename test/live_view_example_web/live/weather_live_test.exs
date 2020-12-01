defmodule LiveViewExampleWeb.WeatherLiveTest do
  use LiveViewExampleWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    
    assert disconnected_html =~ "OpenWeather Station"
    assert render(page_live) =~ "OpenWeather Station"
  end
end
