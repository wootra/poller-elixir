defmodule PollerCore.App do
  @moduledoc """
  PollerCore is a library for creating and managing polls.
  """

  use Application

  def start(_type, _args) do
    children = [
      PollerCore.Db,
      PollerCore.Supervisor
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end
end
