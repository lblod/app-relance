defmodule Dispatcher do
  use Matcher

  define_accept_types [
    json: [ "application/json", "application/vnd.api+json" ],
    html: [ "text/html", "application/xhtml+html" ],
    any: ["*/*"]
  ]

  @json %{ accept: %{ json: true } }
  @html %{ accept: %{ html: true } }
  @any %{ accept: %{ any: true } }


  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule.
  #
  # docker-compose stop; docker-compose rm; docker-compose up
  # after altering this file.
  #
  # match "/themes/*path", _ do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end
  #
  # match "/themes/*path", { last_call: true } do
  #   send_resp( conn, 404, "Route not found, check config/dispatcher.ex" )
  # end

  match "/favicon.ico", @any do
    send_resp( conn, 404, "There is no favicon here" )
  end

  match "/assets/*path", @any do
    Proxy.forward conn, path, "http://fastboot/assets/"
  end

  match "/*path", @html do
    Proxy.forward conn, path, "http://fastboot/"
  end

  match "/local-businesses/*path", @json do
    Proxy.forward conn, path, "http://cache/local-businesses/"
  end

  match "/locations/*path", @json do
    Proxy.forward conn, path, "http://cache/locations/"
  end

  match "/categories/*path", @json do
    Proxy.forward conn, path, "http://cache/categories/"
  end

  match "/opening-hours-specifications/*path", @json do
    Proxy.forward conn, path, "http://cache/opening-hours-specifications/"
  end

  match "/day-of-weeks/*path", @json do
    Proxy.forward conn, path, "http://cache/day-of-weeks/"
  end

  match "/nace-bel-codes/*path", @json do
    Proxy.forward conn, path, "http://cache/nace-bel-codes/"
  end

  get "/extract/*path", @json do
    Proxy.forward conn, path, "http://extract-local-businesses-from-url/"
  end

  match "/*_", %{ last_call: true } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
