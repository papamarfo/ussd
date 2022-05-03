defmodule Ussd.Record do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, :ets.new(:ussd, [:named_table, :public])}
  end

  def get(name) do
    case :ets.lookup(:ussd, name) do
      [{^name, items}] -> {:ok, items}
      [] -> :error
    end
  end

  def new(name) do
    GenServer.call(__MODULE__, {:new, name})
  end

  def add(name, item, value) do
    GenServer.call(__MODULE__, {:add, name, item, value})
  end

  def delete(name) do
    :ets.delete(:ussd, name)
  end

  def handle_call({:new, name}, _from, table) do
    case get(name) do
      {:ok, name} ->
        {:reply, name, table}

      :error ->
        :ets.insert(table, {name, []})
        {:reply, [], table}
    end
  end

  def handle_call({:add, name, item, value}, _from, table) do
    case get(name) do
      {:ok, items} ->
        if Keyword.has_key?(items, item) do
          items = Keyword.delete(items, item)
          items = [{item, value} | items]
          :ets.insert(table, {name, items})

          {:reply, items, table}
        else
          items = [{item, value} | items]
          :ets.insert(table, {name, items})

          {:reply, items, table}
        end

      :error ->
        {:reply, {:error, :list_not_found}, table}
    end
  end
end
