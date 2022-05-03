defmodule Ussd.Decision do
  @moduledoc false

  alias Ussd.{Record, Utils}

  def equal(params, input, state) do
    if params["input"] === input do
      update_state(params, state)
    end

    params
  end

  def between(params, min, max, state) do
    if params["input"] >= min && params["input"] <= max do
      update_state(params, state)
    end

    params
  end

  def in_array(params, list, state) do
    if Enum.member?(list, params["input"]) do
      update_state(params, state)
    end

    params
  end

  def any(params, state) do
    update_state(params, state)
  end

  defp update_state(params, state) do
    Utils.module_exits?(state)

    Record.add(params["session_id"], :state, to_string(state))
  end
end
