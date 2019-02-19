defmodule FreddieClient.Echo do

  alias FreddieClient.Scheme

  def send_echo(socket, msg) do
    req = FreddieClient.Echo.make_msg(msg)
    FreddieClient.Transport.send(socket, req)
  end

  def make_msg(msg) do
    echo = Scheme.Echo.new(msg: msg)
    packet = Freddie.Scheme.Common.new_message(0, echo)
    packet
  end
end
