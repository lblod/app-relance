defmodule Dispatcher do
  use Plug.Router

  def start(_argv) do
    port = 80
    IO.puts "Starting Plug with Cowboy on port #{port}"
    Plug.Adapters.Cowboy.http __MODULE__, [], port: port
    :timer.sleep(:infinity)
  end

  plug Plug.Logger
  plug :match
  plug :dispatch

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule.
  #
  # docker-compose stop; docker-compose rm; docker-compose up
  # after altering this file.
  #
  # match "/themes/*path" do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end

  match "/local-businesses/*path" do
    Proxy.forward conn, path, "http://cache/local-businesses/"
  end

  match "/locations/*path" do
    Proxy.forward conn, path, "http://cache/locations/"
  end

  match "/categories/*path" do
    Proxy.forward conn, path, "http://cache/categories/"
  end

  match "/opening-hours-specifications/*path" do
    Proxy.forward conn, path, "http://cache/opening-hours-specifications/"
  end

  match "/day-of-weeks/*path" do
    Proxy.forward conn, path, "http://cache/day-of-weeks/"
  end

  match "/nace-bel-codes/*path" do
    Proxy.forward conn, path, "http://cache/nace-bel-codes/"
  end

  get "/extract/*path" do
    Proxy.forward conn, path, "http://extract-local-businesses-from-url/"
  end

  #################################################################
  # adressenregister
  #################################################################
  match "/adressenregister/*path" do
    Proxy.forward conn, path, "http://adressenregister/"
  end

  match _ do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
