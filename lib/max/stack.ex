defmodule Max.Stack do
  # Client Code
  def start_link(initial_state \\ []) do
    spawn_link(__MODULE__, :loop, [initial_state])
  end

  def push(pid, item) do
    send(pid, {:push, item})
    :ok
  end

  def pop(pid) do
    send(pid, {:pop, self()})

    # synchronously_wait_for_popped_message()
    receive do
      {:popped, head} ->
        head

      _ ->
        raise "don't know how to process this message"
    end
  end

  # Server
  def loop(state) do
    receive do
      {:push, item} ->
        Process.sleep(5000)
        __MODULE__.loop([item | state])

      {:pop, from} ->
        Process.sleep(5000)
        [head | tail] = state

        send(from, {:popped, head})
        __MODULE__.loop(tail)

      _ ->
        IO.puts("don't know how to process this message")
        __MODULE__.loop(state)
    end
  end
end
