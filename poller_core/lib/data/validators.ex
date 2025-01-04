defmodule PollerCore.Data.Validators do
  @moduledoc """
    A module to validate data.
  """

  alias PollerCore.Data.Question
  alias PollerCore.Data.Choice
  alias PollerCore.Data.Party

  @doc """
    Validates a list of integers.

    ## Examples

        iex> PollerCore.Data.Validator.integer_list([1, 2, 3])
        [1, 2, 3]

        iex> PollerCore.Data.Validator.integer_list([])
        []

        iex> PollerCore.Data.Validator.integer_list([1, 2, "3"])
        ** (ArgumentError) Invalid arguments. should be ([number])
  """

  def question_list([item | more]) do
    [converted_question(item) | question_list(more)]
  end

  def question_list([]), do: []

  def converted_question(%Question{
        id: id,
        choices: choices,
        description: desc
      })
      when is_integer(id) and is_list(choices) and is_bitstring(desc) do
    %Question{
      id: id,
      choices: choice_list(choices),
      description: desc
    }
  end

  def converted_question(_) do
    raise ArgumentError, "Invalid arguments. should be (%Question{
      id: integer,
      choices: [%Choice{}],
      description: string
    })"
  end

  @spec choice_list([Choice.t()]) :: [Choice.t()]
  def choice_list([item | more]) do
    [converted_choice(item) | choice_list(more)]
  end

  def choice_list([]), do: []

  @spec converted_choice(Choice.t()) :: Choice.t()
  def converted_choice(%Choice{
        id: id,
        party: party,
        description: desc
      })
      when is_integer(id) and is_bitstring(desc) do
    %Choice{
      id: id,
      party: converted_party(party),
      description: desc
    }
  end

  def converted_choice(_) do
    raise ArgumentError, "Invalid arguments. should be (%Choice{
      id: integer,
      party: integer,
      description: string
    })"
  end

  def converted_party(
        %Party{
          id: id,
          description: desc
        } = party
      )
      when is_integer(id) and is_bitstring(desc) do
    party
  end

  def converted_party(_) do
    raise ArgumentError, "Invalid arguments. should be (%Party{
      id: integer,
      description: string
    })"
  end
end
