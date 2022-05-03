# Ussd

![Hex.pm](https://img.shields.io/hexpm/v/ussd) ![Hex.pm](https://img.shields.io/hexpm/dt/ussd)

Build Ussd (Unstructured Supplementary Service Data) applications with phoenix without breaking a sweat.

## Installation

The package can be installed
by adding `ussd` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ussd, "~> 0.1.2"}
  ]
end
```

## Usage

### Creating States

We provide a mix command which allows you to quickly create new states.

```mix
mix phx.gen.ussd.state Welcome
```

Generated Welcome state module 

```elixir
defmodule MyModule.States.Welcome do
  alias Ussd.{Menu, Decision}

  def action, do: "input"

  def before_render(_params, menu) do
    menu
    |> Menu.text("Menu")
  end

  def after_render(params) do
    params
    |> Decision.equal("1", Ussd.States.Welcome)
  end
end
```

## Creating Menus

Add your menu to the before_render function

```elixir
defmodule MyModule.States.Welcome do
  alias Ussd.{Menu, Decision}

  def action, do: "input"

  def before_render(_params, menu) do
    menu
    |> Menu.text("Welcome")
    |> Menu.space(2)
    |> Menu.text("Select an option")
    |> Menu.space(2)
    |> Menu.manual_list([
      "Airtime Topup",
      "Data Bundle",
      "TV Subscription",
      "ECG/GWCL",
      "Talk To Us"
    ])
    |> Menu.space(2)
    |> Menu.text("Powered by Pessewa")
  end

  def after_render(_params) do
    # do nothing
  end
end
```

## Linking States with Decisions

Add your decision to the after_render function and link them with states

```elixir
defmodule MyModule.States.Welcome do
  alias Ussd.{Menu, Decision}

  def action, do: "input"

  def before_render(_params, menu) do
    menu
    |> Menu.text("Welcome")
    |> Menu.space(2)
    |> Menu.text("Select an option")
    |> Menu.space(2)
    |> Menu.manual_list([
      "Airtime Topup",
      "Data Bundle",
      "TV Subscription",
      "ECG/GWCL",
      "Talk To Us"
    ])
    |> Menu.space(2)
    |> Menu.text("Powered by Pessewa")
  end

  def after_render(params) do
    params
    |> Decision.equal("1", MyModule.States.Prompt)
  end
end
```

## Setting Initial State

Alias the Ussd.Machine module and pass it to the Machine.state function

```elixir
defmodule MyModule.UssdController do
  use MyModule, :controller

  alias Ussd.Machine

  def index(conn, params) do
    payload =
      conn
      |> Machine.request(%{
        "phone" => params["phone"],
        "network" => params["network"],
        "session_id" => params["session_id"],
        "input" => params["input"] || ""
      })
      |> Machine.state(MyModule.States.Welcome)
      |> Machine.run()

    json(conn, %{
      # change to any response structure you want
      "USSDResp" => %{
        "action" => payload["action"],
        "menu" => "",
        "title" => payload["menu"]
      }
    })
  end
end
```

## License

MIT. Please see the [license file](LICENSE) for more information.