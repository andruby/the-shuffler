defmodule ShuffleRouter do
  require EEx
  use Plug.Router

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded]
  plug :match
  plug :dispatch

  EEx.function_from_file(:def, :index_html, "view/index.html.eex", [:options])

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
    send_resp(conn, 200, index_html(%{}))
  end

  get "/direct-slack-install" do
    conn
    |> put_resp_header("location", "https://slack.com/oauth/authorize?scope=commands&client_id=2168100599.461590182420")
    |> send_resp(302, "You are being redirected")
  end

  get "/oauth_callback" do
    case conn.params["error"] do
      nil -> get_oauth_access_token(conn)
      error -> send_resp(conn, 200, index_html(error: error))
    end
  end

  match _ do
    send_resp(conn, 404, index_html(error: "404 Not Found"))
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
    # TODO: Extract into SlackAPI lib with Tesla
    url = "https://slack.com/api/oauth.access"
    params = %{
      code: conn.params["code"],
      client_id: System.get_env("SLACK_CLIENT_ID"),
      client_secret: System.get_env("SLACK_CLIENT_SECRET"),
    }
    response = HTTPotion.post(url, body: URI.encode_query(params), headers: ["Content-Type": "application/x-www-form-urlencoded"])
    # TODO: Send a success response to the user
    # TODO: Store the team_name and team_id this was saved in
    json = Jason.decode!(response.body)
    case json["ok"] do
      true ->
        IO.puts "App successfully installed to #{json["team_name"]}"
        send_resp(conn, 404, index_html(notice: "App successfully installed to #{json["team_name"]}"))
      false ->
        send_resp(conn, 404, index_html(error: inspect(json)))
    end
  end
end
