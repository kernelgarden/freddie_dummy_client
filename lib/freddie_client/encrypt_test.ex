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

    {:ok, %EncryptTest{socket: socket, is_active: true}}
  end

  @impl true
  def handle_info({:tcp, socket, msg}, %{socket: socket} = state) do
    # We can finally reply to the right client.
    <<header::big-16, msg::binary>> = msg
    IO.puts("Received #{inspect header}, #{inspect byte_size(msg)}, msg => #{inspect(msg, limit: :infinity)}")
    FreddieClient.Message.unpack_msg(socket, msg, 0)

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
