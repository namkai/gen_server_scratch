defmodule Max.Stack do
  @behaviour DankServer

  # Client Code
  def start_link(initial_state \\ []) do
    DankServer.start_link(__MODULE__, initial_state)
  end

  def push(pid, item) do
    :ok = DankServer.cast(pid, {:push, item})
    :ok
  end

  def pop(pid) do
    value = DankServer.call(pid, :pop)
    value
  end

  # Server
  def handle_cast({:push, item}, state) do
    [item | state]
  end

  def handle_call(:pop, state) do
    [head | tail] = state
    {head, tail}
  end
end
