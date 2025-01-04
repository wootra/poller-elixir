defmodule PollerCore.Core do
  @moduledoc """
  PollerCore is a library for creating and managing polls.
  """
  alias PollerCore.Data.{Poll, Question, Choice, Party}
  alias PollerCore.Db

  use GenServer

  @spec start_link([integer], Keyword.t()) :: GenServer.on_start()
  def start_link(_args, opt) do
    district_id = Keyword.get(opt, :district_id, 0)
    name = Keyword.get(opt, :name)
    GenServer.start_link(__MODULE__, get_initial_state(district_id), name: name)
  end

  def get_votes(district_id) when is_integer(district_id) do
    GenServer.call(PollerCore.Db, {:get_poll, district_id})
  end

  def vote(choice_id) when is_integer(choice_id) do
    GenServer.cast(PollerCore.Db, {:vote, choice_id})
  end

  @spec get_party(map(), integer()) :: Party.t()
  defp get_party(parties, id) when is_map(parties) and is_integer(id) do
    name = Map.get(parties, id, "unknown")
    Party.new(id, name)
  end

  defp get_choices(question_id) when is_integer(question_id) do
    Db.get_choices(question_id)
  end

  @spec get_choices_map(%{integer() => String.t()}, [Question.t()]) :: %{
          integer() => [Choice.t()]
        }
  defp get_choices_map(parties, questions) when is_list(questions) do
    questions
    |> Enum.map(
      &{&1.id,
       get_choices(&1.id)
       |> Enum.map(fn choice ->
         Choice.new_converted(
           choice.id,
           choice.description,
           get_party(parties, choice.party)
         )
       end)}
    )
    |> Enum.into(%{})
  end

  @spec get_initial_state(String.t()) :: Poll.t()
  defp get_initial_state(district_id) when is_bitstring(district_id) do
    get_initial_state(String.to_integer(district_id))
  end

  @spec get_initial_state(integer()) :: Poll.t()
  defp get_initial_state(district_id) when is_integer(district_id) do
    # load from database
    parties = PollerCore.Db.get_parties()

    questions =
      PollerCore.Db.get_questions(district_id)

    choice_map = get_choices_map(parties, questions)

    questions =
      questions
      |> Enum.map(
        &Question.new_converted(
          &1.id,
          &1.description,
          Map.get(choice_map, 1, [])
        )
      )

    votes = PollerCore.Db.get_votes(1)

    Poll.new_converted(
      1,
      questions,
      votes
    )
  end

  defp get_initial_state(_) do
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
end
