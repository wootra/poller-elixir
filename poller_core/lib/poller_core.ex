defmodule PollerCore.Core do
  @moduledoc """
  PollerCore is a library for creating and managing polls.
  """
  alias PollerCore.Data.Poll
  alias PollerCore.Data.Question
  alias PollerCore.Data.Choice
  alias PollerCore.Data.Party

  use GenServer

  @spec start_link([integer], Keyword.t()) :: GenServer.on_start()
  def start_link(_args, opt) do
    district_id = Keyword.get(opt, :district_id, 0)
    name = Keyword.get(opt, :name)
    GenServer.start_link(__MODULE__, get_initial_state(district_id), name: name)
  end

  def get_initial_state(district_id \\ 1)

  def get_initial_state(district_id) when is_bitstring(district_id) do
    get_initial_state(String.to_integer(district_id))
  end

  def get_initial_state(1) do
    # load from database
    Poll.new_converted(
      1,
      [
        Question.new_converted(1, "Who will you vote for?", [
          Choice.new_converted(1, "Candidate1", Party.new(1, "Democrat")),
          Choice.new_converted(2, "Candidate2", Party.new(2, "Republican")),
          Choice.new_converted(3, "Candidate3", Party.new(3, "Independent"))
        ]),
        Question.new_converted(2, "Who will you vote for?", [
          Choice.new_converted(4, "Candidate4", Party.new(1, "Democrat")),
          Choice.new_converted(5, "Candidate5", Party.new(2, "Republican")),
          Choice.new_converted(6, "Candidate6", Party.new(3, "Independent"))
        ])
      ],
      %{
        1 => 0,
        2 => 0,
        3 => 0,
        4 => 0,
        5 => 0,
        6 => 0
      }
    )
  end

  def get_initial_state(district_id) when is_integer(district_id) do
    # load from database
    case district_id do
      1 -> get_initial_state(1)
      _ -> raise ArgumentError, "Invalid district_id"
    end
  end

  def get_initial_state(_) do
    raise ArgumentError, "Invalid arguments. should be (integer)"
  end

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl true
  def terminate(_reason, _state) do
    IO.inspect("should save final result to database")
    :ok
  end

  @impl true
  def handle_call(:get_poll, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:vote, choice_id}, state) do
    existing_votes = Map.get(state.votes, choice_id, 0)

    new_state = %Poll{
      state
      | votes: Map.put(state.votes, choice_id, existing_votes + 1)
    }

    {:noreply, new_state}
  end
end
