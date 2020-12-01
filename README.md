# Project
The Weather Temperature project consists of server-side code to fetch the temperature from an external API.

The project was developed using:

* Elixir
* HTTPoison
* Phoenix Framework (Live View)
* OpenWeather API

# Installation and Usage

  1. OpenWeather API key

     This project uses the data from OpenWeather API. Create a free account to get your key accessing [sign-up](https://home.openweathermap.org/users/sign_up).

  2. Set environment variable

```sh
export OPEN_WEATHER_KEY=PUT_YOUR_API_KEY_HERE
```

  3. Clone project
  ```sh
  git clone https://github.com/thvitti/phoenix_weather.git
  cd phoenix_weather
  ```

  4. Fetch Elixir dependencies
    `mix deps.get`

  5. Install Node.js dependencies with `npm install` inside the `assets` directory

  6. Run tests
    `mix test`

  7. Start Phoenix endpoint with `mix phx.server`


  Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

  ![Screen example](/assets/static/images/screen.png)
