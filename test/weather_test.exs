defmodule WeatherTest do
  use ExUnit.Case, async: true

  alias LiveViewExample.Weather

  test "return an api key not null" do
    appid = Weather.get_appid() 

    assert appid != nil

  end

  test "should convert from Kelvin to Celsius" do
    kelvin = 296.48
    expected = 23
    result = Weather.kelvin_to_celsius(kelvin)

    assert expected == result
  end

  test "should return temperature when take a valid location" do
    expected = "Rio de Janeiro"
    
    {:ok, data} = Weather.search_by(expected) 
    
    assert expected == data["name"]
  end

  test "should return not found when take an invalid location" do
    result = Weather.search_by("00000")
    
    assert {:error, "city not found"} == result
  end

  test "should return obligatory message when given an empty location" do
    result = Weather.search_by("")
    
    assert {:error, "location is obligatory"} == result

  end

  test "should return obligatory message when given a nil location" do
    result = Weather.search_by(nil)
    
    assert {:error, "location is obligatory"} == result
  end
  

  test "should return the same temperature when given same location in another idiom" do
    {:ok, krakow_res} = Weather.search_by("Krakow")
    {:ok, cracovia_res} = Weather.search_by("Cracovia")

    assert krakow_res["id"] == cracovia_res["id"]
  end

end
