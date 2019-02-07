defmodule FreddieClient.Echo do

  alias FreddieClient.Scheme

  def send_echo(pid, msg) do
    echo = Scheme.Echo.new(msg: msg)
    {:ok, packet} = Freddie.Scheme.Common.new_message(1, Scheme.Echo.encode(echo))
    FreddieClient.send(pid, packet)
  end
end
