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
          party: Party.t()
        }

  @spec new_converted(integer, String.t(), PollerCore.Data.Party.t()) :: t
  def new_converted(id, description, %Party{} = party)
      when is_integer(id) and is_bitstring(description) do
    %__MODULE__{
      id: id,
      description: description,
      party: party
    }
  end

  def new_converted(_id, _description, _party) do
    raise ArgumentError, "Invalid arguments. should be (integer, string, integer)"
  end
end
