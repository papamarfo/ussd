defmodule Ussd.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Ussd.Record.start_link()
  end
end
