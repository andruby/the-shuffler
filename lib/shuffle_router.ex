defmodule ShuffleRouter do
  require EEx
  use Plug.Router

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded]
  plug :match
  plug :dispatch

  EEx.function_from_file(:def, :index_html, "view/index.html.eex", [])

  get "/" do
    send_resp(conn, 200, index_html())
  end

  post "/shuffle" do
    shuffled = conn.params["text"]
    |> String.split(" ")
    |> Enum.shuffle
    |> Enum.join(" ")

    slack_respond(conn, shuffled)
  end

  post "/random" do
    item = conn.params["text"]
    |> String.split(" ")
    |> Enum.random

    slack_respond(conn, item)
  end

  post "/dice" do
    roll = :rand.uniform(6)

    slack_respond(conn, roll)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp slack_respond(conn, text) do
    json = Jason.encode!(%{
      response_type: "in_channel",
      text: text,
    })

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json)
  end
end
