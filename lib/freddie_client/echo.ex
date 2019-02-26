defmodule FreddieClient.Echo do

  alias FreddieClient.Scheme

  def send_echo(socket, msg) do
    req = FreddieClient.Echo.make_msg(msg)
    FreddieClient.Transport.send(socket, req)
  end

  def make_msg(msg) do
    echo = Scheme.CS_Echo.new(msg: msg)
    packet = Freddie.Scheme.Common.new_message_dummy(1, echo, 0, [])
    packet
  end
end
