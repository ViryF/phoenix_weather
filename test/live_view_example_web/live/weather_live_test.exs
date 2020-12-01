defmodule LiveViewExampleWeb.WeatherLiveTest do
  use LiveViewExampleWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")

    title = "Weather Temperature"
    assert disconnected_html =~ title
    assert render(page_live) =~ title
  end
end
