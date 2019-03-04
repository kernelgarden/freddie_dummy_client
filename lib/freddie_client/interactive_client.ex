defmodule FreddieClient.InteractiveClient do
  use GenServer

  alias __MODULE__
  alias FreddieClient.InteractiveClient.Session

  defstruct session: nil

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def set_aes(aes_key) do
    GenServer.cast(__MODULE__, {:set_aes, aes_key})
  end

  def command(data, opts \\ []) do
    GenServer.cast(__MODULE__, {:command, data, opts})
  end

  defp update_session(client, new_session) do
    %InteractiveClient{client | session: new_session}
  end

  @impl true
  def init(_opts) do
    opts = [:binary, active: true]

    # server에 connect 후에 handshake를 시도한다.
    {:ok, socket} = :gen_tcp.connect('localhost', 5050, opts)

    session = Session.new(socket)

    {:ok, %InteractiveClient{session: session}}
  end

  @impl true
  def handle_cast({:set_aes, aes_key}, state) do
    new_session = Session.update(state.session, :aes_key, aes_key)
    {:noreply, update_session(state, new_session)}
  end

  @impl true
  def handle_cast({:command, data, opts}, state) do
    FreddieClient.InteractiveClient.Sender.send(state.session, data, opts)
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp, _socket, data}, state) do
    new_session = Session.update(state.session, :buffer, <<state.session.buffer::binary, data::binary>>)
    new_session = FreddieClient.InteractiveClient.PacketParser.on_read(new_session)
    {:noreply, update_session(state, new_session)}
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
  def terminate(_reason, _state) do
    :ok
  end

end
