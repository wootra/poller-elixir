defmodule PollerCore.Schema.Validators do
  @moduledoc """
    A module to validate data.
  """

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
  @spec integer_list([integer]) :: [integer]
  def integer_list([item | more]) when is_integer(item) do
    [item | integer_list(more)]
  end

  def integer_list([]), do: []

  def integer_list([_item | _more]) do
    raise ArgumentError, "Invalid arguments. should be ([number])"
  end
end
