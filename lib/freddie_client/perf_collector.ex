defmodule FreddieClient.PerfCollector do
  use GenServer

  require Logger

  defstruct total_received_byte: 0, completed_num: 0, tasks: [], profiling_time: 0, max_num: 0

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(args) do
    session_num = Keyword.get(args, :session_num)
    time = Keyword.get(args, :time)

    Process.flag(:trap_exit, true)

    tasks =
      1..session_num
      |> Enum.each(fn _idx -> bench(time) end)

    {:ok, %FreddieClient.PerfCollector{total_received_byte: 0, completed_num: 0, tasks: tasks, profiling_time: time, max_num: session_num}}
  end

  @impl true
  def handle_cast({:get_result, received}, state) do
    #IO.puts("Received!!! #{received}")

    new_state = %FreddieClient.PerfCollector{state | total_received_byte: state.total_received_byte + received, completed_num: state.completed_num + 1}

    case new_state.completed_num >= state.max_num do
      true ->
        print_result(new_state)
        {:stop, :normal, new_state}
      false ->
        {:noreply, new_state}
    end
  end

  @impl true
  def handle_info({:EXIT, from, reason}, state) do
    #Logger.error(fn -> "acceptor #{inspect from} is down. reason: #{inspect reason}" end)
    {:noreply, state}
  end

  defp print_result(state) do
    IO.puts("Total received bytes #{state.total_received_byte} / #{state.profiling_time}, #{state.completed_num} dummy clients")
  end

  defp bench(time) do
    {:ok, pid} = GenServer.start_link(FreddieClient, [time: time, collector: self()])
    pid
  end
end
