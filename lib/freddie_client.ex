defmodule FreddieClient do
  use GenServer

  defstruct socket: nil, total_recv: 0, is_active: false, collector: nil, msg: []

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def send(pid, data) do
    GenServer.cast(pid, {:command, data})
  end

  def start_interactive_client do
    FreddieClient.InteractiveClient.start_link([])
  end

  @impl true
  def init(opts) do
    # IO.puts("Start FreddieClient...")
    collector = Keyword.get(opts, :collector)
    time = Keyword.get(opts, :time)
    opts = [:binary, active: true]
    {:ok, socket} = :gen_tcp.connect('localhost', 5050, opts)

    # msg = ["FreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_test"]
    # msg = ["FreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_test"]
    msg = [
      "FreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_testFreddieClient.PerfTest.perf_test"
    ]

    packet = FreddieClient.Echo.make_msg(msg)
    FreddieClient.send(self(), packet)

    Process.send_after(self(), :time_over, time)

    {:ok, %FreddieClient{socket: socket, is_active: true, collector: collector, msg: msg}}
  end

  @impl true
  def handle_cast({:command, data}, state) do
    case state.is_active do
      true ->
        case :gen_tcp.send(state.socket, data) do
          {:error, :closed} ->
            {:stop, :normal, state}

          _ ->
            FreddieClient.send(self(), data)
        end

      false ->
        {:stop, :normal, state}
    end

    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp, socket, msg}, %{socket: socket, total_recv: total_recv} = state) do
    # We can finally reply to the right client.
    new_state = %{state | total_recv: total_recv + byte_size(msg)}

    {:noreply, new_state}
  end

  @impl true
  def handle_info(:time_over, state) do
    IO.puts("time over! #{state.total_recv}")
    {:stop, :normal, %FreddieClient{state | is_active: false}}
  end

  @impl true
  def handle_info({:tcp_closed, _socket}, state) do
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp_error, _socket, _reason}, state) do
    {:stop, :normal, state}
  end

  @impl true
  def handle_info({:error, :closed}, state) do
    {:noreply, state}
  end

  @impl true
  def terminate(_reason, state) do
    GenServer.cast(state.collector, {:get_result, state.total_recv})
    :ok
  end
end
