defmodule DankServer do
  @callback handle_call(msg :: any(), state :: any()) :: {response :: any(), new_state :: any()}
  @callback handle_cast(msg :: any(), state :: any()) :: new_state :: any()

  def start_link(module, args) do
    spawn_link(__MODULE__, :loop, [module, args])
  end

  def call(pid, msg) do
    send(pid, {__MODULE__, :call, self(), msg})

    receive do
      {__MODULE__, :call_response, response} ->
        response

      _ ->
        raise "no"
    end
  end

  def cast(pid, msg) do
    send(pid, {__MODULE__, :cast, msg})
    :ok
  end

  def loop(module, state) do
    receive do
      {__MODULE__, :cast, msg} ->
        new_state = module.handle_cast(msg, state)
        __MODULE__.loop(module, new_state)

      {__MODULE__, :call, from, msg} ->
        {response, new_state} = module.handle_call(msg, state)
        send(from, {__MODULE__, :call_response, response})
        __MODULE__.loop(module, new_state)

      _ ->
        raise "thank you"
    end
  end
end
