# The Shuffler

Slack bot providing Randomness-as-a-Service.

Visit https://shuffler.bedesign.be to add it to your Slack.

Supported slack commands:

### Shuffle

```
/shuffle john jane jack
```

### Random

```
/random red green orange
# /random 10
# /random 0..100
# /random help
```

### Dice

```
/dice
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `shuffler` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:shuffler, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/shuffler](https://hexdocs.pm/shuffler).


