defmodule FreddieClient.Echo do

  alias FreddieClient.Scheme

  def send_echo(socket, msg) do
    echo = Scheme.Echo.new(msg: msg)
    {:ok, packet} = Freddie.Scheme.Common.new_message(0, Scheme.Echo.encode(echo))

    FreddieClient.Transport.send(socket, packet)
  end
end
