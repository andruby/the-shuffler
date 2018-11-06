defmodule RandomOrgApi do
  use Tesla

  # plug Tesla.Middleware.Logger
  plug Tesla.Middleware.BaseUrl, "https://api.random.org"
  plug Tesla.Middleware.Headers, [{"Content-Type", "application/json-rpc"}]
  plug Tesla.Middleware.JSON

  def get_usage() do
    json_rpc_request("getUsage")
  end

  # Uses the generateBlobs API method to get random bits and turns them into
  # unsigned ints, good for :rand.seed
  def random_org_ints(count, size_in_bits) do
    {:ok, response} = json_rpc_request("generateBlobs", %{n: count, size: size_in_bits, format: "hex"})
    response["random"]["data"]
    |> Enum.map(fn(hex) ->
      {uint, _rest} = Integer.parse(hex, 16)
      uint
    end)
  end

  defp json_rpc_request(method, params \\ %{}) do
    payload = %{
      jsonrpc: "2.0",
      method: method,
      params: Map.put(params, :apiKey, Application.get_env(:shuffler, :random_org_api_key)),
      id: 42,
    }
    {:ok, response = %Tesla.Env{status: 200}} = post("/json-rpc/1/invoke", Jason.encode!(payload))
    case response do
      %Tesla.Env{body: %{"error" => error}} -> {:error, error["message"]}
      %Tesla.Env{body: %{"result" => result}} -> {:ok, result}
    end
  end
end
