defmodule PollerCore.Data.Choice do
  @moduledoc """
  A struct to represent a poll.
  """

  defstruct id: nil, description: nil, party: nil

  alias PollerCore.Data.Party

  @type t :: %__MODULE__{
          id: integer,
          description: String.t(),
          # 1: Democrat, 2: Republican, 3: Independent
          party: integer
        }

  @type t2 :: %__MODULE__{
          id: integer,
          description: String.t(),
          # 1: Democrat, 2: Republican, 3: Independent
          party: Party.t()
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

  @spec new_converted(integer, String.t(), PollerCore.Data.Party.t()) :: t2
  def new_converted(id, description, %Party{} = party)
      when is_integer(id) and is_bitstring(description) do
    %__MODULE__{
      id: id,
      description: description,
      party: party
    }
  end

  def new_converted(_, _, _) do
    raise ArgumentError, "Invalid arguments. should be (integer, string, integer)"
  end
end
