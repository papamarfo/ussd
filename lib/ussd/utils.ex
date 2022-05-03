defmodule Ussd.Utils do
  @moduledoc false
  def module_exits?(module) do
    case Code.ensure_compiled(module) do
      {:module, _} ->
        module

      {:error, _} ->
        raise("module #{module} does not exist")
    end
  end
end
