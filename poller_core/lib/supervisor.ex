defmodule PollerCore.Supervisor do
  @moduledoc """
    supervise the PollerCore GenServer
  """

  use DynamicSupervisor

  @spec init_poller(String.t(), integer) :: {:ok, pid, atom()} | {:error, String.t()}
  def init_poller(name, district_id) when is_bitstring(name) and is_integer(district_id) do
    init_poller(String.to_atom(name), district_id)
  end

  @spec init_poller(atom(), integer) :: {:ok, pid, atom()} | {:error, String.t()}
  def init_poller(name, district_id) when is_atom(name) and is_integer(district_id) do
    spec = {PollerCore.Core, [name: name, district_id: district_id]}

    case DynamicSupervisor.start_child(__MODULE__, spec) do
      {:ok, pid} -> {:ok, pid, name}
      {:error, reason} -> {:error, reason}
    end
  end

  def start_link(init_args) do
    DynamicSupervisor.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  @impl true
  def init(init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one, extra_arguments: [init_arg])
  end
end
