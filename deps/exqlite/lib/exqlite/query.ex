defmodule Exqlite.Query do
  @moduledoc """
  Query struct returned from a successfully prepared query.
  """
  @type t :: %__MODULE__{
          statement: iodata(),
          name: atom() | String.t(),
          ref: reference() | nil,
          command: :insert | :delete | :update | nil
        }

  defstruct statement: nil,
            name: nil,
            ref: nil,
            command: nil

  def build(options) do
    statement = Keyword.get(options, :statement)
    name = Keyword.get(options, :name)
    ref = Keyword.get(options, :ref)

    command =
      case Keyword.get(options, :command) do
        nil -> extract_command(statement)
        value -> value
      end

    %__MODULE__{
      statement: statement,
      name: name,
      ref: ref,
      command: command
    }
  end

  defp extract_command(nil), do: nil

  defp extract_command(statement) do
    cond do
      String.contains?(statement, "INSERT") -> :insert
      String.contains?(statement, "DELETE") -> :delete
      String.contains?(statement, "UPDATE") -> :update
      true -> nil
    end
  end

  defimpl DBConnection.Query do
    def parse(query, _opts) do
      query
    end

    def describe(query, _opts) do
      query
    end

    def encode(_query, params, _opts) do
      params
    end

    def decode(_query, result, _opts) do
      result
    end
  end

  defimpl String.Chars do
    def to_string(%{statement: statement}) do
      IO.iodata_to_binary(statement)
    end
  end
end
