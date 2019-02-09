defmodule ShufflerWeb.PageController do
  use ShufflerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
