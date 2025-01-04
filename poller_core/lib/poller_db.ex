defmodule PollerCore.Db do
  @moduledoc """
  A module to interact with the database.
  """
  use GenServer

  alias PollerCore.Schema.{Choice, Question}

  @spec start_link([integer]) :: GenServer.on_start()
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @spec get_parties() :: %{number() => String.t()}
  def get_parties() do
    %{
      1 => "Democrat",
      2 => "Republican",
      3 => "Independent"
    }
  end

  @spec get_votes(integer()) :: %{integer() => integer()}
  def get_votes(district_id) when is_integer(district_id) do
    GenServer.call(__MODULE__, {:get_poll, district_id})
  end

  @spec get_questions(integer | String.t()) :: [Question.t()]
  def get_questions(district_id \\ 1)

  @spec get_questions(String.t()) :: [Question.t()]
  def get_questions(district_id) when is_bitstring(district_id) do
    get_questions(String.to_integer(district_id))
  end

  @spec get_questions(integer) :: [Question.t()]
  def get_questions(1) do
    # load from database
    [
      Question.new(1, "Who will you vote for(1)?", []),
      Question.new(2, "Who will you vote for(2)?", [])
    ]
  end

  @spec get_questions(any()) :: [Question.t()]
  def get_questions(_district_id), do: []

  def get_choices(question_id \\ 1)

  @spec get_choices(integer | String.t()) :: [Choice.t()]
  def get_choices(question_id) when is_bitstring(question_id) do
    get_choices(String.to_integer(question_id))
  end

  @spec get_choices(integer | String.t()) :: [Choice.t()]
  def get_choices(1) do
    # temporary
    [
      Choice.new(1, "Candidate1", 1),
      Choice.new(2, "Candidate2", 2),
      Choice.new(3, "Candidate3", 3)
    ]
  end

  @spec get_choices(integer | String.t()) :: [Choice.t()]
  def get_choices(2) do
    # temporary
    [
      Choice.new(4, "Candidate4", 1),
      Choice.new(5, "Candidate5", 2),
      Choice.new(6, "Candidate6", 3)
    ]
  end

  @spec get_choices(integer | String.t()) :: [Choice.t()]
  def get_choices(_question_id), do: []

  @impl true
  def init(_init_arg) do
    {:ok, %{}}
  end

  @impl true
  def terminate(_reason, _state) do
    IO.inspect("should save final result to database")
    :ok
  end

  @impl true
  def handle_call({:get_poll, _district_id}, _from, state) do
    # in real scenario, it should be filtered with district_id
    {:reply, state, state}
  end

  @impl true
  def handle_call(_, _from, state), do: {:reply, state, state}

  @impl true
  def handle_cast({:vote, choice_id}, state) do
    existing_votes = Map.get(state, choice_id, 0)

    new_state = Map.put(state, choice_id, existing_votes + 1)

    {:noreply, new_state}
  end

  @impl true
  def handle_cast(_, state) do
    {:noreply, state}
  end
end
