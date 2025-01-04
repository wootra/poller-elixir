defmodule PollerCore.Schema.Question do
  @moduledoc """
  A struct to represent a poll.
  """
  alias PollerCore.Schema.Validators

  defstruct id: nil, description: nil, choices: []

  @type t :: %__MODULE__{
          id: integer,
          description: String.t(),
          # [PollerCore.Data.Choice.id]
          choices: [Choice.t()]
        }

  @spec new(integer, String.t(), [integer]) :: t
  def new(id, description, choices \\ [])

  @spec new(integer, String.t(), [integer]) :: t
  def new(id, description, choices)
      when is_integer(id) and is_bitstring(description) and is_list(choices) do
    %__MODULE__{
      id: id,
      description: description,
      choices: Validators.integer_list(choices)
    }
  end

  def new(_id, _description, _choices),
    do: raise(ArgumentError, "Invalid arguments. should be (integer, string, [number])")
end
