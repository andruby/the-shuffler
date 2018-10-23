defmodule ShuffleRouter do
  require EEx
  use Plug.Router

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded]
  plug :match
  plug :dispatch

  EEx.function_from_file(:def, :index_html, "view/index.html.eex", [:error])

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

  get "/" do
    send_resp(conn, 200, index_html(nil))
  end

  get "/direct-slack-install" do
    conn
    |> put_resp_header("location", "https://slack.com/oauth/authorize?scope=commands&client_id=2168100599.461590182420")
    |> send_resp(302, "You are being redirected")
  end

  get "/oauth_callback" do
    case conn.params["error"] do
      nil -> get_oauth_access_token(conn)
      error -> send_resp(conn, 200, index_html(conn.params["error"]))
    end
  end

  match _ do
    send_resp(conn, 404, index_html("404 Not Found"))
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

  defp get_oauth_access_token(conn) do
    code = conn.params["code"]
    # POST https://slack.com/api/oauth.access as application/x-www-form-urlencoded
    # code: code
    # client_id: ENV[]
    # client_secret: ENV[]
    # Get the team_name and team_id and store it somewhere.
  end
end
