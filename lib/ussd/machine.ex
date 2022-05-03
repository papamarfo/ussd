defmodule Ussd.Machine do
  @moduledoc false

  alias Ussd.{Record, Utils}

  def request(_conn, params) do
    params
    |> validate_params()
    |> save_params()
  end

  def state(params, initial_state) do
    set_initial_state(params, initial_state)
  end

  defp validate_params(params) do
    if is_nil(params["phone"]), do: raise("phone is required")
    if is_nil(params["network"]), do: raise("network is required")
    if is_nil(params["session_id"]), do: raise("session_id is required")
    if is_nil(params["input"]), do: raise("input is required")

    params
  end

  defp save_params(params) do
    session_id = params["session_id"]

    case Record.get(session_id) do
      {:ok, _session} ->
        :ok

      :error ->
        session_id
        |> Record.new()
        |> Record.add(:phone, params["phone"])
        |> Record.add(:network, params["network"])
        |> Record.add(:session_id, params["session_id"])
    end

    params
  end

  defp set_initial_state(params, initial_state) do
    Utils.module_exits?(initial_state)

    session_id = params["session_id"]
    {:ok, session} = Record.get(session_id)

    if is_nil(session[:state]) do
      Record.add(session_id, :state, to_string(initial_state))
      Record.add(session_id, :callback, "before_render")
    end

    params
  end

  def run(params) do
    {:ok, session} = Record.get(params["session_id"])

    process_callback(session[:state], session[:callback], params)
  end

  defp process_callback(state, callback, params) do
    if callback == "before_render" do
      process_before_render_callback(state, params)
    else
      process_after_render_callback(state, params)
    end
  end

  defp process_before_render_callback(state, params) do
    Record.add(params["session_id"], :callback, "after_render")

    menu = get_menu(state, :before_render, params)
    action = get_action(state)

    render_menu(params, action, menu)
  end

  defp process_after_render_callback(state, params) do
    Record.add(params["session_id"], :callback, "before_render")

    get_menu(state, :after_render, params)

    run(params)
  end

  defp get_action(state) do
    apply(String.to_atom("#{state}"), :action, [])
  end

  defp get_menu(state, callback, params) do
    if callback == :before_render do
      apply(String.to_atom("#{state}"), :before_render, [params, ""])
    else
      apply(String.to_atom("#{state}"), callback, [params])
    end
  end

  defp render_menu(params, action, menu) do
    if action === "prompt", do: Record.delete(params["session_id"])

    %{"action" => action, "menu" => menu}
  end
end
