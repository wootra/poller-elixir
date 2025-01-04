defmodule PollerCoreTest do
  @moduledoc """
  Tests for the PollerCore.Core module.
  """
  use ExUnit.Case
  doctest PollerCore.Core

  test "get_initial_state(1) should return Poll struct" do
    assert %PollerCore.Data.Poll{} = PollerCore.Core.get_initial_state(1)
  end
end
