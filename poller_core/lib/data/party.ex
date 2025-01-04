defmodule PollerCore.Data.Party do
  @moduledoc """
  A struct to represent a party.
  """

  defstruct id: nil, description: nil

  @type t :: %__MODULE__{
          id: integer,
          description: String.t()
        }

  def new(id, description) when is_integer(id) and is_bitstring(description) do
    %__MODULE__{
      id: id,
      description: description
    }
  end

  def new(_id, _description) do
    raise ArgumentError, "Invalid arguments. should be (integer, string)"
  end
end
