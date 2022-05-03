defmodule <%= module %> do
  alias Ussd.{Menu, Decision}

  def action, do: "input"

  def before_render(menu) do
    menu
    |> Menu.text("Menu")
  end

  def after_render(params) do
    params
    |> Decision.equal("1", Ussd.States.Welcome)
  end
end
