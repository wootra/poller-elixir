defmodule PollerCore.Schema.Poll do
  @moduledoc """
  A struct to represent a poll.
  """

  alias PollerCore.Schema.Validators

  defstruct(
    district_id: nil,
    questions: [],
    votes: %{}
  )

  @type t :: %__MODULE__{
          district_id: integer,
          # [PollerCore.Data.Question.id]
          questions: [integer()],
          votes: %{
            # PollerCore.Data.Choice.id => vote_count
            integer => integer
          }
        }

  @spec new(integer, [integer]) :: t
  def new(district_id, questions \\ [])

  @spec new(integer, [integer]) :: t
  def new(district_id, questions) when is_integer(district_id) and is_list(questions) do
    %__MODULE__{
      district_id: district_id,
      questions: Validators.integer_list(questions),
      votes: %{}
    }
  end

  def new(_district_id, _questions) do
    raise ArgumentError, "Invalid arguments. should be (integer, [number])"
  end
end
