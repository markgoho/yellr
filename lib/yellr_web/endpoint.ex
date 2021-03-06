defmodule YellrWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :yellr

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_yellr_key",
    signing_salt: "LWX8dfA/"
  ]

  socket "/socket", YellrWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :yellr,
    gzip: false,
    only: ~w(css fonts media images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug YellrWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      new_config = load_config_from_environment(config)
      {:ok, new_config}
    else
      {:ok, config}
    end
  end

  defp load_config_from_environment(config) do
    port = System.get_env("PORT") || "8080"
    host = System.get_env("HOST") || "localhost"
    config
      |> Keyword.put(:http, [:inet6, port: port])
      |> Keyword.put(:url, [host: host, port: port])
      |> Keyword.put(:x_api_key, get_api_key())
  end

  if (Mix.env == :prod) do
    defp get_api_key do
      System.get_env("API_KEY")
    end
  else
    defp get_api_key do
      "TESTKEY"
    end
  end
end
