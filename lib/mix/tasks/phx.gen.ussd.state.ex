defmodule Mix.Tasks.Phx.Gen.Ussd.State do
  @shortdoc "Generates a Ussd state file"

  @moduledoc """
  Generates a Ussd state file.

      mix phx.gen.ussd.state Welcome

  The first argument is the module name

  Overall, this generator will add the following file to `lib/app/states/`:
  """

  use Mix.Task

  @doc false
  def run(args) do
    [state_name] = validate_args!(args)
    context_app = Mix.Phoenix.context_app()
    context_lib_prefix = Mix.Phoenix.context_lib_path(context_app, "")
    binding = Mix.Phoenix.inflect(state_name)
    binding = Keyword.put(binding, :module, "#{binding[:base]}.States.#{binding[:scoped]}")

    Mix.Phoenix.check_module_name_availability!(binding[:module])

    Mix.Phoenix.copy_from(paths(), "priv/templates/phx.gen.ussd.state", binding, [
      {:eex, "state.ex", Path.join(context_lib_prefix, "states/#{binding[:path]}.ex")}
    ])
  end

  @spec raise_with_help() :: no_return()
  defp raise_with_help do
    Mix.raise("""
    mix phx.gen.ussd.state expects a module name:

      mix phx.gen.ussd.state Welcome

    """)
  end

  defp validate_args!(args) do
    unless length(args) == 1 do
      raise_with_help()
    end

    args
  end

  defp paths do
    [".", :ussd]
  end
end
