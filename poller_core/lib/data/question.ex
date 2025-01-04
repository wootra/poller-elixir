defmodule PollerCore.Data.Question do
  @moduledoc """
  A struct to represent a poll.
  """
  alias PollerCore.Data.Validators
  alias PollerCore.Data.Choice

  defstruct id: nil, description: nil, choices: []

  @type t :: %__MODULE__{
          id: integer,
          description: String.t(),
          # [PollerCore.Data.Choice.id]
          choices: [Choice.t()]
        }

  @spec new_converted(integer, String.t(), [Choice.t()]) :: t
  @spec new_converted(integer(), bitstring(), [PollerCore.Data.Choice.t()]) ::
          PollerCore.Data.Question.t()
  def new_converted(id, description, choices \\ [])

  @spec new_converted(integer, String.t(), [Choice.t()]) :: t
  def new_converted(id, description, choices)
      when is_integer(id) and is_bitstring(description) and is_list(choices) do
    %__MODULE__{
      id: id,
      description: description,
      choices: Validators.choice_list(choices)
    }
  end

  def new_converted(_id, _description, _choices),
    do: raise(ArgumentError, "Invalid arguments. should be (integer, string, [%{Choice}])")
end
