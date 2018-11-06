defmodule Shuffler.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    better_rand_seed()

    # List all child processes to be supervised
    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: ShuffleRouter, options: [port: 4000])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Shuffler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp better_rand_seed do
    IO.puts "Providing the PRNG with a better algo and seed from RANDOM.org"
    uints = RandomOrgApi.random_org_ints(3, 32) |> List.to_tuple
    :rand.seed(:exsplus, uints)
  end
end
