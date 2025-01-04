defmodule PollerCore.Schema.Choice do
  @moduledoc """
  A struct to represent a poll.
  """

  defstruct id: nil, description: nil, party: nil

  @type t :: %__MODULE__{
          id: integer,
          description: String.t(),
          # 1: Democrat, 2: Republican, 3: Independent
          party: integer()
        }

  @spec new(integer, String.t(), integer) :: t
  def new(id, description, party)
      when is_integer(id) and is_bitstring(description) and is_integer(party) do
    %__MODULE__{
      id: id,
      description: description,
      party: party
    }
  end

  def new(_, _, _) do
    raise ArgumentError, "Invalid arguments. should be (integer, string, integer)"
  end
end
