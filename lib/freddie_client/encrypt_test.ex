defmodule FreddieClient.EncryptTest do
  use GenServer

  alias __MODULE__

  defstruct socket: nil, is_active: false, recv_queue: <<>>

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def send(pid, data) do
    GenServer.cast(pid, {:command, data})
  end

  @impl true
  def init(_opts) do
    opts = [:binary, active: true]
    {:ok, socket} = :gen_tcp.connect('localhost', 5050, opts)

    Process.send_after(self(), {:ping}, 3_000)

    {:ok, %EncryptTest{socket: socket, is_active: true}}
  end

  @impl true
  def handle_info({:tcp, socket, msg}, %{socket: socket} = state) do
    <<header::big-16, msg::binary>> = msg
    FreddieClient.Message.unpack_msg(socket, msg, 0)

    {:noreply, state}
  end

  @impl true
  def handle_info({:ping}, state) do
    request = FreddieClient.Scheme.CS_EncryptPing.new(msg: "Ping!", idx: 0)
    FreddieClient.Message.send_message(state.socket, 3, request)
    {:noreply, state}
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
    :ok
  end

end
