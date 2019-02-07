defmodule FreddieClient do
  use GenServer

  defstruct socket: nil, total_recv: 0, is_active: false, collector: nil

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def send(pid, data) do
    GenServer.cast(pid, {:command, data})
  end

  @impl true
  def init(opts) do
    IO.puts("Start FreddieClient...")
    collector = Keyword.get(opts, :collector)
    time = Keyword.get(opts, :time)
    opts = [:binary, active: true]
    {:ok, socket} = :gen_tcp.connect('localhost', 5050, opts)
    FreddieClient.Echo.send_echo(self(), "Hello, world!")

    Process.send_after(self(), :time_over, time)

    {:ok, %FreddieClient{socket: socket, is_active: true, collector: collector}}
  end

  @impl true
  def handle_cast({:command, data}, state) do
    msg = Freddie.Utils.pack_message(data)
    :ok = :gen_tcp.send(state.socket, msg)
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp, socket, msg}, %{socket: socket, total_recv: total_recv} = state) do
    # We can finally reply to the right client.
    #IO.puts("reply from server: #{inspect msg}")
    new_state = %{state | total_recv: total_recv + byte_size(msg)}
    FreddieClient.Echo.send_echo(self(), "Hello, world!")

    {:noreply, new_state}
  end

  @impl true
  def handle_info(:time_over, state) do
    IO.puts("time over! #{state.total_recv}")
    GenServer.cast(state.collector, {:get_result, state.total_recv})
    {:stop, :normal, state}
  end

  @impl true
  def handle_info({:tcp_closed, _socket}, state) do
    {:noreply, state}
  end
end
